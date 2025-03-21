terraform {
  required_version = "=1.8.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# S3
module "s3" {
  source   = "./modules/s3"
  app_name = var.app_name
  region   = var.region
}

# IAM
module "iam" {
  source           = "./modules/iam"
  app_name         = var.app_name
  region           = var.region
  s3_bucket_name   = module.s3.s3_bucket_name
  kendra_index_arn = module.kendra.kendra_index_arn
}

# kendra
module "kendra" {
  source          = "./modules/kendra"
  app_name        = var.app_name
  s3_bucket_name  = module.s3.s3_bucket_name
  iam_role_kendra = module.iam.iam_role_kendra
  s3_bucket_id    = module.s3.s3_bucket_id
}

# lambda
module "lambda" {
  source            = "./modules/lambda"
  iam_role_lambda   = module.iam.iam_role_lambda
  app_name          = var.app_name
  api_execution_arn = module.apigateway.api_execution_arn
  kendra_index_id   = module.kendra.kendra_index_id
}

# apigateway
module "apigateway" {
  source                  = "./modules/apigateway"
  lambda_invoke_arn       = module.lambda.lambda_invoke_arn
  iam_role_lambda         = module.iam.iam_role_lambda
  region                  = var.region
  app_name                = var.app_name
  api_gateway_endpoint_id = module.network.api_gateway_endpoint_id
}

# ECR
module "ecr" {
  source     = "./modules/ecr"
  image_name = var.image_name
  app_name   = var.app_name
}

# BASH
module "bash" {
  source     = "./modules/bash"
  region     = var.region
  image_name = var.image_name
}

# network
module "network" {
  source   = "./modules/network"
  app_name = var.app_name
  api_port = var.api_port
}

# ELB
module "elb" {
  source                     = "./modules/elb"
  app_name                   = var.app_name
  region                     = var.region
  api_port                   = var.api_port
  main_vpc_id                = module.network.main_vpc_id
  subnet_public_subnet_1a_id = module.network.subnet_public_subnet_1a_id
  subnet_public_subnet_1c_id = module.network.subnet_public_subnet_1c_id
  sg_alb_id                  = module.network.sg_alb_id
}

# ECS
module "ecs" {
  source                      = "./modules/ecs"
  app_name                    = var.app_name
  sg_ecs_id                   = module.network.sg_ecs_id
  subnet_private_subnet_1a_id = module.network.subnet_private_subnet_1a_id
  subnet_public_subnet_1a_id  = module.network.subnet_public_subnet_1a_id
  aws_iam_role                = module.iam.iam_role_ecs
  api_repository_url          = module.ecr.api_repository_url
  lb_target_group_web_arn     = module.elb.lb_target_group_web_arn
  api_port                    = var.api_port
  http_arn                    = module.elb.http_arn
  api_gateway_endpoint        = module.apigateway.api_gateway_endpoint
}




