variable "cluster_name" {
  type    = string
  default = "aws"
}

variable "ssh_key_name" {
  type    = string
}

variable "worker_count" {
  type    = number
}

variable "region" {
  type    = string
}

module "k3s_master" {
  source = "../k3s_master"

  region       = var.region
  cluster_name = var.cluster_name
  ssh_key_name = var.ssh_key_name
}

module "k3s_workers" {
  source = "../k3s_workers"

  region       = var.region
  cluster_name = var.cluster_name
  ssh_key_name = var.ssh_key_name

  worker_count      = var.worker_count
  security_group_id = module.k3s_master.security_group_id
  subnet_ids        = module.k3s_master.subnet_ids
  master_dns_name   = module.k3s_master.master_dns_name
  master_token      = module.k3s_master.master_token

}

