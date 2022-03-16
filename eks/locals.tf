locals {
  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name      = "cluster-autoscaler-aws"
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}


variable "cluster_name" {
  type = string
  description = "Cluster name imported from module declaration"
}

variable "instance_type" {
  type = string
  description = "Instance type"
}

variable "asg_desired_capacity" {
  type = number
  description = "Autoscaling group desired capacity"
}

variable "asg_min_capacity" {
  type = number
  description = "Autoscaling group min capacity"
}

variable "asg_max_capacity" {
  type = number
  description = "Autoscaling group max capacity"
}
