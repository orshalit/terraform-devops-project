variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default = "us-east-2"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default = "nadav-proj-vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default = "10.0.0.0/16"
}
variable "public_subnet_name" {
  description = "The name of the public subnet"
  type        = string
  default = "nadav-proj-public-subnet"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_name" {
  description = "The name of the private subnet"
  type        = string
  default = "nadav-proj-private-subnet"
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = list(string)
  default = ["10.0.16.0/20", "10.0.32.0/20", "10.0.48.0/20"]
  
}

variable "public_route_table_name" {
  description = "The name of the public route table"
  type        = string
  default = "nadav-proj-public-rt"
}

variable "private_route_table_name" {
  description = "The name of the private route table"
  type        = string
  default = "nadav-proj-private-rt"
}

variable "nat_gw_name" {
  description = "The name of the NAT gateway"
  type        = string
  default = "nadav-proj-nat-gw"
}

variable "availability_zones" {
  description = "The availability zones to deploy into"
  type        = list(string)
  default = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "igw_name" {
  description = "The name of the internet gateway"
  type        = string
  default = "nadav-proj-igw"
  
}


