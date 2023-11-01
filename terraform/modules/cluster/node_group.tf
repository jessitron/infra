resource "aws_eks_node_group" "main" {
  depends_on = [
    aws_iam_openid_connect_provider.main,
  ]

  cluster_name    = aws_eks_cluster.main.name
  instance_types  = ["t3.medium"]
  node_group_name = "main"
  node_role_arn   = aws_iam_role.node.arn

  scaling_config {
    desired_size = 4
    max_size     = 5
    min_size     = 3
  }

  subnet_ids = var.private_subnet_ids
}

resource "aws_iam_role" "node" {
  name = "eks-${var.cluster_name}-node"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }
  })

  // Required policies from:
  // https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  ]
}
