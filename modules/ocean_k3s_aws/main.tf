variable "cluster_name" {
  type    = string
  default = "ocean"
}

variable "ssh_key_name" {
  type    = string
}

variable "region" {
  type    = string
}

variable "ocean_controller_token" {
  type    = string
}

variable "ocean_account" {
  type    = string
}

module "k3s_master" {
  source = "../k3s_master"

  region       = var.region
  cluster_name = var.cluster_name
  ssh_key_name = var.ssh_key_name
  install_ocean_controller = true
  ocean_controller_token = var.ocean_controller_token
  ocean_account = var.ocean_account
}

module "k3s_workers" {
  source = "../ocean_workers"

  cluster_name = var.cluster_name
  ssh_key_name = var.ssh_key_name

  region            = var.region
  security_group_id = module.k3s_master.security_group_id
  subnet_ids        = module.k3s_master.subnet_ids
  master_dns_name   = module.k3s_master.master_dns_name
  master_token      = module.k3s_master.master_token

}

