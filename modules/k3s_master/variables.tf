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

variable "install_ocean_controller" {
  default = false
}

variable "ocean_controller_token" {
  type    = string
  default = ""
}

variable "ocean_account" {
  type    = string
  default = ""
}
