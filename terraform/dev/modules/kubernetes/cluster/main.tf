#----------------------
# main.tf
# - Planned Resources
#----------------------

#------------------------
# Planned Resources
# - resource blocks only
#------------------------
# Kubernetes Cluster
resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = var.name
  region  = var.region_code
  version = var.resource_version

  # Default Node Pool
  node_pool {
    name       = var.name + "-core-np"
    size       = var.size
    auto_scale = var.auto_scale
    min_nodes  = var.min_nodes
    max_nodes  = var.max_nodes
    labels = {
      nodepool = var.name + "-core-np"
    }
  }
}}