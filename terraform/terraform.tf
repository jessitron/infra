terraform {
  backend "s3" {
    bucket = "jessitron-infra"
    key = "infra/terraform/terraform.tfstate"
    region = "us-west-2"
  }
}
