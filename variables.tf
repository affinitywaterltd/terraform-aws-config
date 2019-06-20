data "aws_caller_identity" "current" {}

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

variable "tags" {
  default = {
    "owner"   = "Infrastructure"
    "project" = "AWL-Config"
    "client"  = "Internal"
  }
}
