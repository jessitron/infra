terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.58"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.18"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Why = "Something Something Observability"
    }
  }
}

data "aws_region" "main" {}

locals {
  region = data.aws_region.main.name
}

// https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/3.19.0
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "pixie-lou-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

module "cluster" {
  source = "./modules/cluster"

  depends_on = [
    module.vpc,
  ]

  cluster_name       = "pixie-lou"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  public_subnet_ids  = module.vpc.public_subnets
}

provider "kubernetes" {
  host                   = module.cluster.endpoint
  cluster_ca_certificate = base64decode(module.cluster.ca_certificate)
  token                  = module.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = module.cluster.endpoint
    cluster_ca_certificate = base64decode(module.cluster.ca_certificate)
    token                  = module.cluster.token
  }
}


output "dammit" {
  value = "work dammit"
}


output "supposedly-subnet-ids" {
  value = module.vpc.private_subnets
}

