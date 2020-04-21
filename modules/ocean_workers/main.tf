provider "spotinst" { }

provider "aws" {
  region = var.region
}


module "k3s_worker_profile" {
  source = "../k3s_worker_profile"

  cluster_name = var.cluster_name
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



resource "spotinst_ocean_aws" "example" {
  name = var.cluster_name
  controller_id = var.cluster_name
  region = var.region

  max_size         = 100
  min_size         = 0
  desired_capacity = 1

  subnet_ids = var.subnet_ids

  // --- LAUNCH CONFIGURATION --------------
  image_id             = data.aws_ami.latest_amzn.id
  security_groups      = ["${var.security_group_id}"]
  key_name             = var.ssh_key_name
  user_data            = local.worker_userdata
  iam_instance_profile = module.k3s_worker_profile.worker_profile_id
  root_volume_size     = 20

  associate_public_ip_address = true

  tags {
    key   = "KubernetesCluster"
    value = var.cluster_name
  }

  lifecycle {
    ignore_changes = [
      desired_capacity
    ]
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
