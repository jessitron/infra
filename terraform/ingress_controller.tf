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

resource "aws_s3_bucket_acl" "alb_log_bucket_policy" {
  bucket = aws_s3_bucket.alb_log_bucket.id
  acl = "public-read"
#   access_control_policy = {

#     /*
#     {
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
#     */ 
#     {
#     grant {
#       grantee {
#         id   = data.aws_canonical_user_id.current.id
#         type = "CanonicalUser"
#       }
#       permission = "READ"
#     }

#     grant {
#       grantee {
#         type = "Group"
#         uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
#       }
#       permission = "READ_ACP"
#     }

#     owner {
#       id = data.aws_canonical_user_id.current.id
#     }
#   }
#  }
}
