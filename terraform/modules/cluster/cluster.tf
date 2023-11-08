resource "aws_eks_cluster" "main" {
  depends_on = [
    aws_cloudwatch_log_group.cluster,
  ]

  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn

  version = "1.25" // https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html

  // https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]

  vpc_config {
    endpoint_public_access = true // WARNING: Bastion would be safer -- this is for demo only.
    subnet_ids             = setunion(var.private_subnet_ids, var.public_subnet_ids)
    security_group_ids     = [aws_security_group.cluster.id]
  }

  tags = {
    "cluster-name" = var.cluster_name
    "eks:cluster-name" = var.cluster_name
  }
}

data "aws_eks_cluster_auth" "main" {
  name = aws_eks_cluster.main.name
}

resource "aws_cloudwatch_log_group" "cluster" {
  name = "/aws/eks/${var.cluster_name}/cluster"
}

resource "aws_iam_role" "cluster" {
  name = "eks-${var.cluster_name}-cluster"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }
  })

  managed_policy_arns = [
    // Required for any cluster.
    // https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  ]
}

resource "aws_security_group" "cluster" {
  name        = "eks-${var.cluster_name}-cluster"
  description = "eks-${var.cluster_name}-cluster"
  vpc_id      = var.vpc_id

  tags = {
    Name = "eks-${var.cluster_name}-cluster"
  }
}

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "main" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.cluster.url
}
