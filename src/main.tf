terraform {
  # Run init/plan/apply with "backend" commented-out (ueses local backend) to provision Resources (Bucket, Table)
  # Then uncomment "backend" and run init, apply after Resources have been created (uses AWS)
  backend "s3" {
    bucket         = "tmb-tf-state-backend-ci-cd"
    key            = "tf-infra/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_version = "~> 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-3"
}

module "tf-state" {
  source      = "./modules/tf-state"
  bucket_name = "tmb-tf-state-backend-ci-cd"
}

module "vpc-infra" {
  source = "./modules/vpc"

  # VPC Input Vars
  vpc_cidr             = local.vpc_cidr
  availability_zones   = local.availability_zones
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
}
