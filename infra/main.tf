terraform {
  required_version = "=1.10.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# IAM
module "iam" {
  source   = "./modules/iam"
  app_name = var.app_name
}

# lambda
module "lambda" {
  source                      = "./modules/lambda"
  iam_role_lambda             = module.iam.iam_role_lambda
  app_name                    = var.app_name
  subnet_private_subnet_1a_id = module.network.subnet_private_subnet_1a_id
  lambda_sg_id                = module.network.lambda_sg_id
}

# network
module "network" {
  source   = "./modules/network"
  app_name = var.app_name
}
