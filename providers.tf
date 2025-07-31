terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      cost-center = "aws-cert"
      app         = "vpc-privatelink"
      project     = "sap-c02"
    }
  }
}

