variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-2"
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
  default     = "445521015129"
}

variable "aws_profile" {
  description = "The AWS profile to use"
  type        = string
  default     = "devops"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "nadav-proj-eks-cluster"
}

variable "eks_version" {
  description = "The desired Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets"
  type        = list(string)
  default     = ["subnet-05528d6fe1dbb40cd", "subnet-00ee6a2ef24ed89d7", "subnet-0c28beef4f48b0f56"]
}

variable "public_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
  default     = ["subnet-085f161b2986033ee", "subnet-0e39fd76a2875e0c7", "subnet-02c71f53bdf8ab51f"]
}

variable "eks_worker_node_role_name" {
  description = "The name of the IAM role for the EKS worker nodes"
  type        = string
  default     = "nadav-proj-eks-cluster-eks-node-role"
}