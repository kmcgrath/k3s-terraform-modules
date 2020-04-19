provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "k3s-${var.cluster_name}"
  cidr = "10.0.0.0/16"

  azs             = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[0]}"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster = var.cluster_name
  }
}


module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "k3s-${var.cluster_name}-sg"
  description = "Security group wth custom ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  egress_cidr_blocks       = ["10.0.0.0/16"]
  egress_with_cidr_blocks  = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "outbound"
      cidr_blocks = "0.0.0.0/0"
    }
  ]


  ingress_cidr_blocks      = ["10.0.0.0/16"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
      description = "Kubernetes API"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = 10250
      to_port     = 10250
      protocol    = "tcp"
      description = "kubelet"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = 8472
      to_port     = 8472
      protocol    = "udp"
      description = "VXLAN"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

