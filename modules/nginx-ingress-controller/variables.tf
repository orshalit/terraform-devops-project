variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-2"

}

variable "aws_profile" {
  description = "The AWS profile to use"
  type        = string
  default     = "devops"

}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  default     = "vpc-0b28ddb86c17e7519"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "devops-proj-eks-cluster"
}

variable "cluster_sg_id" {
  description = "The ID of the security group for the EKS cluster"
  type        = string
  default     = "sg-0ef14a3059642f6d2"
}

variable "eks_version" {
  description = "The desired Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets"
  type        = list(string)
  default     = ["subnet-09af63e01d1c7f045", "subnet-0ab762180ab21432f", "subnet-057c8ab28fe57e075"]
}

variable "public_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
  default     = ["subnet-08fba0a8d0f738a14", "subnet-08839ba36382a5256", "subnet-0c12574b0c864e79b"]
}

variable "eks_worker_node_role_name" {
  description = "The name of the IAM role for the EKS worker nodes"
  type        = string
  default     = "devops-proj-eks-cluster-eks-node-role"
}

variable "https_node_port" {
  description = "The port for the HTTPS service"
  type        = number
  default     = 31443
}

variable "http_node_port" {
  description = "The port for the HTTP service"
  type        = number
  default     = 31080
}

variable "node_group_instance_arns" {
  description = "The ARNs of the instances in the EKS node group"
  type        = list(string)
  default     = ["arn:aws:eks:us-east-2:992382397622:nodegroup/devops-proj-eks-cluster/devops-proj-eks-cluster-node-group/8ec79785-6cdf-e5b6-0919-4cca23d932b6"]
}
variable "node_group_role" {
  description = "The ARN of the node group role"
  type        = string
  default     = "arn:aws:iam::992382397622:role/devops-proj-eks-cluster-eks-node-role"
}
