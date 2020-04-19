output "worker_profile_id" {
  value = "${aws_iam_instance_profile.k3s_worker_profile.id}"
}
