variable "cluster_name" {
  type        = string
  default     = "k3s_ocean"
  description = "Name for the k3s cluster"
}

variable "ssh_key_name" {
  type        = string
  description = "Name of the AWS SSH Key to use"
}

variable "security_group_id" {
  type        = string
  description = "AWS SecurityGroup the workers will be associated with"
}

variable "subnet_ids" {
  type        = list(string)
  description = "AWS Subnet IDs the workers will be launched in"
}

variable "master_dns_name" {
  type        = string
  description = "The k3s master DNS name"
}

variable "master_token" {
  type        = string
  description = "k3s master token"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

