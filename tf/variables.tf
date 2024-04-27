#VPC
variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "us-east1"
}

variable "cluster_name" {
  description = "veeva-cluster"
}

variable "nodepool_name" {
  description = "veeva-nodepool"
}

variable "kube_host" {
  description = "veeva-kube-host"
}

variable "primary_cidr_range" {
  description = "veeva-kube-host"
}