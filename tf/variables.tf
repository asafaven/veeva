#VPC
variable "project_id" {
  description = "project id"
  default = "veeva"
}

variable "region" {
  default = "us-east1"
}

variable "zone" {
  default = "us-east1-b"
}

variable "cluster_name" {
  default = "veeva-cluster"
}

variable "nodepool_name" {
  default = "veeva-nodepool"
}

variable "kube_host" {
  default = "veeva-kube-host"
}

# variable "primary_cidr_range" {
#   description = "veeva-kube-host"
# }