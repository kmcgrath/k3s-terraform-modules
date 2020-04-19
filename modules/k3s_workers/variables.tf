variable "worker_count" {
  type    = number
  default = 1
}

variable "cluster_name" {
  type    = string
}

variable "ssh_key_name" {
  type    = string
}

variable "security_group_id" {
  type    = string
}

variable "subnet_ids" {
  type    = list(string)
}

variable "master_dns_name" {
  type    = string
}

variable "master_token" {
  type    = string
}

variable "region" {
  type    = string
}
