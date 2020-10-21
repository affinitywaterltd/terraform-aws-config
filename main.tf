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

# -----------------------------------------------------------
# set up the Config Recorder rules
# see https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html
# -----------------------------------------------------------
/*
resource "aws_config_config_rule" "instances_in_vpc" {
  name = "instances_in_vpc"

  source {
    owner             = "AWS"
    source_identifier = "INSTANCES_IN_VPC"
  }

  depends_on = [aws_config_configuration_recorder.config]
}*/

resource "aws_config_config_rule" "ec2_volume_inuse_check" {
  name = "ec2_volume_inuse_check"

  source {
    owner             = "AWS"
    source_identifier = "EC2_VOLUME_INUSE_CHECK"
  }

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "ec2_stopped_instance" {
  name = "ec2_stopped_instance"

  source {
    owner             = "AWS"
    source_identifier = "EC2_STOPPED_INSTANCE"
  }

  input_parameters = <<EOF
  {
    "AllowedDays": "30"
  }
  EOF

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "eip_attached" {
  name = "eip_attached"

  source {
    owner             = "AWS"
    source_identifier = "EIP_ATTACHED"
  }

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "ec2_security_group_attached_to_eni" {
  name = "ec2_security_group_attached_to_eni"

  source {
    owner             = "AWS"
    source_identifier = "EC2_SECURITY_GROUP_ATTACHED_TO_ENI"
  }

  depends_on = [aws_config_configuration_recorder.config]
}
/*
resource "aws_config_config_rule" "encrypted_volumes" {
  name = "encrypted_volumes"

  source {
    owner             = "AWS"
    source_identifier = "ENCRYPTED_VOLUMES"
  }

  depends_on = [aws_config_configuration_recorder.config]
}*/

resource "aws_config_config_rule" "incoming_ssh_disabled" {
  name = "incoming_ssh_disabled"

  source {
    owner             = "AWS"
    source_identifier = "INCOMING_SSH_DISABLED"
  }

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "vpc_flow_logs_enabled" {
  name = "vpc_flow_logs_enabled"

  source {
    owner             = "AWS"
    source_identifier = "VPC_FLOW_LOGS_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.config]
}

// see https://docs.aws.amazon.com/config/latest/developerguide/cloudtrail-enabled.html
resource "aws_config_config_rule" "cloud_trail_enabled" {
  name = "cloud_trail_enabled"

  source {
    owner             = "AWS"
    source_identifier = "CLOUD_TRAIL_ENABLED"
  }

  input_parameters = <<EOF
{
  "s3BucketName": "cloudtrail-786188916060"
}
EOF


  depends_on = [aws_config_configuration_recorder.config]
}
/*
resource "aws_config_config_rule" "cloudwatch_alarm_action_check" {
  name = "cloudwatch_alarm_action_check"

  source {
    owner             = "AWS"
    source_identifier = "CLOUDWATCH_ALARM_ACTION_CHECK"
  }

  input_parameters = <<EOF
{
  "alarmActionRequired" : "true",
  "insufficientDataActionRequired" : "false",
  "okActionRequired" : "false"
}
EOF


  depends_on = [aws_config_configuration_recorder.config]
}*/
/*
resource "aws_config_config_rule" "iam_group_has_users_check" {
  name = "iam_group_has_users_check"

  source {
    owner             = "AWS"
    source_identifier = "IAM_GROUP_HAS_USERS_CHECK"
  }

  depends_on = [aws_config_configuration_recorder.config]
}*/

//see https://docs.aws.amazon.com/config/latest/developerguide/iam-password-policy.html
resource "aws_config_config_rule" "iam_password_policy" {
  name = "iam_password_policy"

  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }

  input_parameters = <<EOF
{
  "RequireUppercaseCharacters" : "true",
  "RequireLowercaseCharacters" : "true",
  "RequireSymbols" : "true",
  "RequireNumbers" : "true",
  "MinimumPasswordLength" : "8",
  "PasswordReusePrevention" : "12",
  "MaxPasswordAge" : "60"
}
EOF


  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "iam_user_group_membership_check" {
  name = "iam_user_group_membership_check"

  source {
    owner             = "AWS"
    source_identifier = "IAM_USER_GROUP_MEMBERSHIP_CHECK"
  }

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "iam_user_no_policies_check" {
  name = "iam_user_no_policies_check"

  source {
    owner             = "AWS"
    source_identifier = "IAM_USER_NO_POLICIES_CHECK"
  }

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "root_account_mfa_enabled" {
  name = "root_account_mfa_enabled"

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "s3_bucket_public_read_prohibited" {
  name = "s3_bucket_public_read_prohibited"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "s3_bucket_public_write_prohibited" {
  name = "s3_bucket_public_write_prohibited"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "s3_bucket_logging_enabled" {
  name = "s3_bucket_logging_enabled"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_LOGGING_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.config]
}
/*
resource "aws_config_config_rule" "s3_bucket_ssl_requests_only" {
  name = "s3_bucket_ssl_requests_only"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SSL_REQUESTS_ONLY"
  }

  depends_on = [aws_config_configuration_recorder.config]
}*/

resource "aws_config_config_rule" "s3_bucket_server_side_encryption_enabled" {
  name = "s3_bucket_server_side_encryption_enabled"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "s3_bucket_versioning_enabled" {
  name = "s3_bucket_versioning_enabled"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "ebs_optimized_instance" {
  name = "ebs_optimized_instance"

  source {
    owner             = "AWS"
    source_identifier = "EBS_OPTIMIZED_INSTANCE"
  }

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_config_rule" "ec2_required_tags" {
  name = "ec2_required_tags"

  scope {
    compliance_resource_types = ["AWS::EC2::Instance"]
  }

  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }

  input_parameters = <<EOF
{
  "tag1Key" : "Terraform",
  "tag1Value" : "True",
  "tag2Key" : "CostCentre"
}
EOF

  depends_on = [aws_config_configuration_recorder.config]
}
