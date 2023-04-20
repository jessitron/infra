terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "local" {
    path = "../../../../Dropbox/state/infra.tfstate"
  }

  required_version = ">= 1.2.0"
}
