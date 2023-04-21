module "load_balancer_controller" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-lb-controller.git"

  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  cluster_name                     = local.cluster_name
}

# This bucket is for putting ALB logs into
resource "aws_s3_bucket" "alb_log_bucket" {
  bucket = "otel-demo-alb-access-logs"

  tags = {
    Notes = "debug 502s from the collector endpoint"
  }
}

resource "aws_s3_bucket_policy" "work_dangit" {
  bucket = aws_s3_bucket.alb_log_bucket.id
  policy = data.aws_iam_policy_document.work_dangit_policy.json
}

data "aws_iam_policy_document" "work_dangit_policy" {
#   {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "arn:aws:iam::elb-account-id:root"
#       },
#       "Action": "s3:PutObject",
#       "Resource": "arn:aws:s3:::bucket-name/prefix/AWSLogs/your-aws-account-id/*"
#     }
#   ]
# }
  statement {
    principals {
      type        = "AWS"
      identifiers = ["414852377253"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.alb_log_bucket.arn,
      "${aws_s3_bucket.alb_log_bucket.arn}/prefix/AWSLogs/414852377253/*",
    ]
  }
}
