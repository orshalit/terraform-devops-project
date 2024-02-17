terraform {
  required_version = ">= 0.14"
  backend "s3" {
    bucket = "nadav-project"
    key    = "vpc/terraform.tfstate"
    region = "us-east-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}
