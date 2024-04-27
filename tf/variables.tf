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