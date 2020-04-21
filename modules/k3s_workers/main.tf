provider "aws" {
  region = var.region
}

data "aws_ami" "latest_amzn" {
  most_recent = true
  owners = ["amazon"]

  filter {
      name   = "name"
      values = ["amzn2-ami-hvm-2.0.????????.?-x86_64-gp2"]
  }

  filter {
      name   = "state"
      values = ["available"]
  }
}


module "k3s_worker_profile" {
  source = "../k3s_worker_profile"

  cluster_name = "${var.cluster_name}"
}

module "k3s_workers" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name           = "k3s-worker-${var.cluster_name}"
  instance_count = "${var.worker_count}"

  ami                    = data.aws_ami.latest_amzn.id
  instance_type          = "t2.medium"
  key_name               = "${var.ssh_key_name}"
  vpc_security_group_ids = ["${var.security_group_id}"]
  subnet_id              = var.subnet_ids[0]
  user_data              = "${local.worker_userdata}"
  iam_instance_profile   = "${module.k3s_worker_profile.worker_profile_id}"
  associate_public_ip_address = true

  tags = {
    KubernetesCluster = "${var.cluster_name}"
  }
}



locals {

  worker_userdata = <<EOF
#!/usr/bin/bash

curl -sfL https://get.k3s.io | sh -s agent --server https://${var.master_dns_name}:6443 \
  --token "${var.master_token}"  \
  --kubelet-arg="cloud-provider=external" \
  --kubelet-arg="provider-id=aws:///$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)/$(curl -s http://169.254.169.254/latest/meta-data/instance-id)"

EOF
}
