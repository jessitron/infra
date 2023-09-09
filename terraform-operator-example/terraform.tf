terraform {
  backend "s3" {
    bucket = "jessitron-infra"
    key    = "infra/terraform-operator-example/terraform.tfstate"
    region = "us-west-2"
  }

  resource "helm_release" "cert-manager" {
    name       = "cert-manager"
    repository = "jetstack https://charts.jetstack.io"
    chart      = "jetstack/cert-manager"

    values = [
      file("${path.module}/cert-manager-values.yaml")
    ]
  }
}
