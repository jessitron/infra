
provider "aws" {
  region = "us-west-2"
}

locals {
  cluster_name = "otel-demo-qcon-london-23"
}

resource "aws_instance" "bananapants-on-ec2" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
