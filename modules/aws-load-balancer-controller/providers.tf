locals {
  kubeconfig = "C:\\Users\\97250\\.kube\\new-kubeconfig.conf"
}

terraform {
  required_version = ">= 0.14"
  backend "s3" {
    bucket = "devops-project-terraform"
    key    = "aws-load-balancer-controller/terraform.tfstate"
    region = "us-east-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "helm" {
  kubernetes {
    config_path = local.kubeconfig
  }
}

provider "kubernetes" {
  config_path = local.kubeconfig
}
provider "aws" {
  region = var.region
}
