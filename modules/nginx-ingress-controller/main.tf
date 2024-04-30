resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.9.1"

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "external"
  }

  set {
    name  = "controller.service.type"
    value = "NodePort" # The ALB will route traffic to these NodePorts
  }

  set {
    name  = "controller.service.nodePorts.http"
    value = var.http_node_port
  }

  set {
    name  = "controller.service.nodePorts.https"
    value = var.https_node_port
  }

  set_list {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-subnets"
    value = var.public_subnet_ids
  }
  # depends_on = [aws_eks_node_group.main]
}

data "aws_iam_policy_document" "alb_ingress_policy" {
  statement {
    actions = [
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:GetCertificate"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcs",
      "ec2:DescribeRegions"
      # Potentially add additional EC2 permissions as required
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:RemoveListenerCertificates",
      # Potentially add additional ELB permissions as required
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "iam:CreateServiceLinkedRole"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "iam:AWSServiceName"
      values   = ["elasticloadbalancing.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "nginx_ingress_alb_policy" {
  name        = "NginxIngressALBPolicy"
  path        = "/"
  description = "Policy for allowing NGINX Ingress to manage AWS ALB resources"
  policy      = data.aws_iam_policy_document.alb_ingress_policy.json
}

resource "aws_iam_role_policy_attachment" "nginx_ingress_alb_attach" {
  policy_arn = aws_iam_policy.nginx_ingress_alb_policy.arn
  role       = var.eks_worker_node_role_name # Make sure to use the actual IAM role of your EKS worker nodes
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    # Allow inbound HTTP traffic to the ALB from the internet
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Allow inbound HTTPS traffic to the ALB from the internet
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    # Allow all outbound traffic from the ALB
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-alb-sg"
  }
}

resource "aws_lb" "nginx_alb" {
  name               = "${var.cluster_name}-nginx"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Name = "${var.cluster_name}-nginx-alb"
  }
}

data "aws_instances" "instance_list" {
  instance_tags = {
    "eks:nodegroup-name" = "devops-proj-eks-cluster-node-group"  # Filter instances by tag
  }

  instance_state_names = ["running"]  # Filter instances by state
}

resource "aws_lb_target_group" "nginx_tg_http" {
  name     = "${var.cluster_name}-tg-http"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  target_type = "instance"
}

resource "aws_lb_listener" "nginx_http" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg_http.arn
  }
}

resource "aws_lb_listener_rule" "nginx_http_rule" {
  listener_arn = aws_lb_listener.nginx_http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg_http.arn
  }

  condition {
    host_header {
      values = ["example.com"]
    }
  }
}

resource "aws_lb_target_group_attachment" "nginx_tg_attachment" {
  count            = length(data.aws_instances.instance_list.ids)
  target_group_arn = aws_lb_target_group.nginx_tg_http.arn
  target_id        = data.aws_instances.instance_list.ids[count.index]
}

# resource "aws_lb_target_group" "nginx_tg_https" {
#   name     = "${var.cluster_name}-tg-https"
#   port     = 443
#   protocol = "HTTPS"
#   vpc_id   = var.vpc_id

#   health_check {
#     protocol            = "HTTPS"  # Adjust if your health check endpooint doesn't support HTTPS.
#     path                = "/"  # Adjust the health check path as necessary.
#     matcher             = "200"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 3
#     unhealthy_threshold = 3
#   }

#   target_type = "ip"  # We use "ip" targeting for Ingress Controllers
# }

# resource "aws_lb_listener" "nginx_https" {
#   load_balancer_arn = aws_lb.nginx_alb.arn
#   port              = 443
#   protocol          = "HTTPS"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.nginx_tg_https.arn
#   }
# }

# resource "aws_eks_node_group" "main" {
#   cluster_name    = var.cluster_name
#   node_group_name = "${var.cluster_name}-node-group"
#   node_role_arn   = var.node_group_role # Role ARN created for the EKS nodes
#   subnet_ids      = var.private_subnet_ids

#   scaling_config {
#     desired_size = 1
#     max_size     = 3
#     min_size     = 1
#   }

#   launch_template {
#     id      = aws_launch_template.eks_node_launch_template.id
#     version = "$Latest"
#   }
# }

resource "aws_launch_template" "eks_node_launch_template" {
  name_prefix   = "eks-node-launch-template"
  instance_type = "t3.small"
  image_id      = "ami-010feaf9c3bddd955" # Optimized AMI for EKS worker nodes us-east-2

  vpc_security_group_ids = [
    aws_security_group.eks_nodes_sg.id,
  ]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.cluster_name}-node"
    }
  }
}

# # IAM role for EKS worker nodes
# resource "aws_iam_role" "eks_node_role" {
#   name = "${var.cluster_name}-eks-node-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         },
#         Action = "sts:AssumeRole"
#       },
#     ],
#   })
# }

# # Managed policy attachment for EKS worker nodes role
# resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
# }

# resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" # Required for EKS CNI plugin
# }

# resource "aws_iam_role_policy_attachment" "eks_registry_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" # Allows nodes to pull images from ECR
# }

# Security Group for EKS Nodes to allow traffic from ALB
resource "aws_security_group" "eks_nodes_sg" {
  name        = "${var.cluster_name}-eks-nodes-sg"
  description = "Security group for EKS nodes to receive traffic from ALB"
  vpc_id      = var.vpc_id # Make sure this is the ID of your VPC

  # All traffic from EKS cluster
  ingress {
    description     = "Allow traffic from master nodes to worker nodes"
    from_port       = 30000
    to_port         = 32767
    protocol        = "tcp"
    security_groups = [var.cluster_sg_id]
  }

  ingress {
    description     = "Allow traffic from ALB to NodePort range"
    from_port       = 30000
    to_port         = 32767
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Reference the ALB's security group
  }

  # Allow EKS nodes to communicate freely within the VPC
  ingress {
    description = "Intra-VPC communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr] # Reference the VPC's CIDR block
  }

  egress {
    description = "Allow all outbound traffic from the EKS nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-eks-nodes"
  }
}

