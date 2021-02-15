# -----------------------------------------------------------
# set up the  Config Recorder - test
# -----------------------------------------------------------

resource "aws_config_configuration_recorder" "config" {
  name     = var.config_name
  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/awl-config"

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "config" {
  name           = var.config_name
  s3_bucket_name = var.bucket_name
  s3_key_prefix  = var.bucket_key_prefix
  sns_topic_arn  = var.sns_topic_arn

  snapshot_delivery_properties {
    delivery_frequency = "Three_Hours"
  }

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_configuration_recorder_status" "config" {
  name       = "awl-config"
  is_enabled = true

  depends_on = [aws_config_delivery_channel.config]
}

resource "aws_config_configuration_aggregator" "config" {
  count = var.aggregator_account_id == data.aws_caller_identity.current.account_id ? 1 : 0
  name  = "config_aggregator"

  account_aggregation_source {
    account_ids = var.account_aggregation_source_account_ids
    regions     = length(var.account_aggregation_source_regions) > 0 ? var.account_aggregation_source_regions : [data.aws_region.current.name]
  }
}

resource "aws_config_aggregate_authorization" "config" {
  account_id = var.aggregator_account_id
  region     = data.aws_region.current.name
}