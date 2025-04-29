#--------------
# variables.tf
#--------------

variable "name" {
  description = "Nodepool Name"
  type        = string
}

variable "region_code" {
  description = "Kubernetes Cluster deployment region code"
  type        = string
}

variable "resource_version" {
  description = "DOKS Version"
  type        = string
}

# Ref: https://docs.digitalocean.com/products/kubernetes/details/limits/#allocatable-memory
variable "size" {
  description = "Nodepool Size"
  type        = string
}

variable "auto_scale" {
  description = "Enable Nodepool Autoscaling"
  type        = bool
}

variable "min_nodes" {
  description = "Minimum Number of Nodes in Nodepool"
  type        = number
}

variable "max_nodes" {
  description = "Maximum Number of Nodes in Nodepool"
  type        = number
}