module "eks-alb-ingress" {
  source  = "lablabs/eks-alb-ingress/aws"
  version = "0.6.0"
  # insert the 4 required variables here
  cluster_identity_oidc_issuer = "" # i have no idea what goes here
  # aws iam list-open-id-connect-providers
  cluster_identity_oidc_issuer_arn =""
  cluster_name = local.cluster_name
  enabled = true # I guess??
}
