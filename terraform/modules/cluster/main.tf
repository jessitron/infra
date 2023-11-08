variable "cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = set(string)
}

output "PrivateSubnetIDs" {
  value = var.private_subnet_ids[*]
}

variable "public_subnet_ids" {
  type = set(string)
}

output "endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "ca_certificate" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}

output "token" {
  value = data.aws_eks_cluster_auth.main.token
}
