// Follows the guide in: https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html

data "http" "load_balancer_controller_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy.json"
}

resource "aws_iam_role" "load_balancer_controller" {
  name = "eks-${var.cluster_name}-lbcontroller"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.main.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${aws_iam_openid_connect_provider.main.url}:aud" = "sts.amazonaws.com"
          "${aws_iam_openid_connect_provider.main.url}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }
  })

  inline_policy {
    name   = "aws-load-balancer-controller"
    policy = data.http.load_balancer_controller_policy.response_body
  }
}

resource "kubernetes_service_account_v1" "load_balancer_controller" {
  depends_on = [
    aws_eks_cluster.main,
    aws_iam_openid_connect_provider.main,
  ]

  metadata {
    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
    }
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.load_balancer_controller.arn
    }
  }
}

resource "helm_release" "load_balancer_controller" {
  depends_on = [
    aws_eks_node_group.main,
    aws_iam_openid_connect_provider.main,
  ]

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  name       = "aws-load-balancer-controller"
  version    = "1.4.8"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = aws_eks_cluster.main.name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account_v1.load_balancer_controller.metadata[0].name
  }
}
