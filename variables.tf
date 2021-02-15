data "aws_caller_identity" "current" {
}

data "aws_region" "current" {}

variable "bucket_prefix" {
  default = "awl-config"
}

variable "bucket_key_prefix" {
  default = "config"
}

variable "bucket_name" {
  default = "awl-config"
}

variable "config_name" {
  default = "awl-config"
}

variable "sns_topic_arn" {
  default = ""
}

variable "aggregator_account_id" {
  default = ""
}

variable "account_aggregation_source_account_ids" {
  type = list
  default = []
}

variable "account_aggregation_source_regions" {
  type = list
  default = []
}

variable "tags" {
  default = {
    "owner"   = "Infrastructure"
    "project" = "AWL-Config"
    "client"  = "Internal"
  }
}

