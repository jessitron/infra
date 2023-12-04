
# This bucket is for putting ALB logs into
resource "aws_s3_bucket" "alb_log_bucket" {
  bucket = "otel-demo-alb-access-logs"

  tags = {
    Notes = "debug 502s from the collector endpoint"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "dumb_encryption_thing" {
  bucket = aws_s3_bucket.alb_log_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      # kms_master_key_id = aws_kms_key.mykey.arn # there is a default one
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_policy" "work_dangit" {
  bucket = aws_s3_bucket.alb_log_bucket.id
  policy = data.aws_iam_policy_document.work_dangit_policy.json
}

data "aws_elb_service_account" "main" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "work_dangit_policy" {

  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.alb_log_bucket.arn,
      "${aws_s3_bucket.alb_log_bucket.arn}/sso-demo-alb/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
      "${aws_s3_bucket.alb_log_bucket.arn}/quiz-booth-game-alb/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]
  }
}
