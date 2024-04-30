variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-2"
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
  default     = "992382397622"
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

variable "public_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
  default     = ["subnet-08fba0a8d0f738a14", "subnet-08839ba36382a5256", "subnet-0c12574b0c864e79b "]
}

variable "eks_worker_node_role_name" {
  description = "The name of the IAM role for the EKS worker nodes"
  type        = string
  default     = "devops-proj-eks-cluster-eks-node-role"
}