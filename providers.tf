provider "aws" {
  region = "eu-west-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket           = "terraform-state-240435431181"
    key              = "terraform.tfstate"
    region           = "eu-west-1"
    encrypt          = true
    force_path_style = true
  }
}