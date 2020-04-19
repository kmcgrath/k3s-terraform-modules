# k3s-terraform-modules

Modules for testing and development of k3s with Ocean by Spot


## Ocean k3s

* VPC with 2 subnets in region of choice
* k3s master
* [AWS k8s Cloud Provider][cloud-provider-aws-url]
* [AWS EBS CSI Driver][ebs-csi-driver-url]
* Ocean by Spot worker nodes

Provision master and Ocean workers

```
module "spotinst_ocean_controller" {
  source = "github.com/kmcgrath/k3s-terraform-modules//modules/ocean_k3s_aws"

  ocean_account               = "act-XXXXXX"
  ocean_controller_token      = "SECRET"
  region                      = "us-east-1"
  ssh_key_name                = "my-key"
  cluster_name                = "ocean-k3s"
}
```


## k3s only

* VPC with 2 subnets in region of choice
* k3s master
* [AWS k8s Cloud Provider][cloud-provider-aws-url]
* [AWS EBS CSI Driver][ebs-csi-driver-url]
* Worker nodes

Provision master and Ocean workers

```
module "spotinst_ocean_controller" {
  source = "github.com/kmcgrath/k3s-terraform-modules//modules/ocean_k3s_aws"

  region                      = "us-east-1"
  ssh_key_name                = "my-key"
  worker_count                = 1
}
```


[cloud-provider-aws-url]: https://github.com/kubernetes/cloud-provider-aws
[ebs-csi-driver-url]: https://github.com/kubernetes-sigs/aws-ebs-csi-driver
