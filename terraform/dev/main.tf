#----------------------
# main.tf
# - Common Expressions
# - Planned Resources
# - Referenced Configs
#----------------------

#----------------------
# Common Expressions
# - locals blocks only
#----------------------
locals {
  general_size = "g-4vcpu-16gb"
  medium_size  = "s-4vcpu-8gb"
}

#------------------------
# Planned Resources
# - resource blocks only
#------------------------
# Sefire Staging Environment using DOKS
resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = "sefire-sgp1-dev"
  region  = "sgp1"
  version = "1.32.2-do.0"

  # Default Node Pool
  node_pool {
    name       = "testing"
    size       = local.general_size # change this depending on dev cluster spinning up resource requirements
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 5
    labels = {
      nodepool = "testing"
    }
  }
}