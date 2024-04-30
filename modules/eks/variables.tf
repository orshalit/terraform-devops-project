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

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "devops-proj-eks-cluster"
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
variable "node_group_desired_size" {
  description = "Desired number of nodes in the node group"
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the node group"
  default     = 3
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in the node group"
  default     = 1
}

variable "instance_types" {
  type        = list(string)
  description = "List of EC2 instance types for the node group"
  default = ["t3.small"]
}

variable "ami_type" {
  type        = string
  description = "AMI type for the nodes"
  default     = "AL2_x86_64"
}