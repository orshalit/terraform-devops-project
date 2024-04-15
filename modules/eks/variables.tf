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
  default     = ["subnet-0d36f7eac6b6bb969", "subnet-005d2a3a0b0329a52", "subnet-02b79d9fa28e64a36"]
}