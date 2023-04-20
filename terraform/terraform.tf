terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.64"
    }
  }

  backend "local" {
    path = "../../../../Dropbox/state/infra.tfstate"
  }

  required_version = ">= 1.2.0"
}
