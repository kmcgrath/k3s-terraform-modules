output "security_group_id" {
  value = "${module.sg.this_security_group_id}"
}

output "subnet_ids" {
  value = module.vpc.public_subnets
}

output "master_dns_name" {
  value = "${module.k3s_master.private_dns[0]}"
}

output "master_token" {
  value = "${random_uuid.token.result}"
}

