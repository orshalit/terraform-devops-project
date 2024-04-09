locals {
  kubeconfig = "./new-kubeconfig.conf"
}

terraform {
  required_version = ">= 0.14"
  backend "s3" {
    bucket = "nadav-project"
    key    = "nginx-ingress-controller/terraform.tfstate"
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
