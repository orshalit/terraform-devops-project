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
  default     = "vpc-0f00e004e81de71b3"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "nadav-proj-eks-cluster"
}

variable "cluster_sg_id" {
  description = "The ID of the security group for the EKS cluster"
  type        = string
  default     = "sg-0e50d9ac8d1d88833"  
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
  default     = ["arn:aws:eks:us-east-2:445521015129:nodegroup/nadav-proj-eks-cluster/nadav-proj-eks-cluster-node-group/04c6dc47-18e9-8aa1-63d4-a687d9f49af9"]
}