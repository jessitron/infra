terraform {
  backend "s3" {
    bucket = "jessitron-infra"
    key = "infra/terraform-operator-example/terraform.tfstate"
    region = "us-west-2"
  }
}
