data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "17.24.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.21"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  enable_irsa     = true

  write_kubeconfig = false

  worker_groups = [
	{
	  name                 = "worker-group-1"
	  instance_type        = var.instance_type
	  asg_desired_capacity = var.asg_desired_capacity
	  asg_min_size = var.asg_min_capacity
	  asg_max_size = var.asg_max_capacity

	  tags = [
		{
		  key = "k8s.io/cluster-autoscaler/enabled"
		  propagate_at_launch = "true"
		  value = "true"
		},
		{
		  key = "k8s.io/cluster-autoscaler/${var.cluster_name}"
		  propagate_at_launch = "true"
		  value = "owned"
		}
	  ]
	}
  ]

//  map_roles                            = var.map_roles
  map_users                            = var.map_users
//  map_accounts                         = var.map_accounts
}
