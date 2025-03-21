data "aws_caller_identity" "self" {}
locals {
  account_id = data.aws_caller_identity.self.account_id
}
variable "app_name" {}
variable "region" {}
variable "s3_bucket_name" {}
variable "kendra_index_arn" {}
