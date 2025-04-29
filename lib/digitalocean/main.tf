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

#--------------------------------------------------------
# Planned Resources
# - resource blocks only
# - place here if speed is prioritised; modularise later
#--------------------------------------------------------

#----------------------
# Referenced Configs
# - module blocks only
#----------------------
# Module Config for Sefire Development Environment using DOKS
module "sgp1_cluster" {
  source           = "./modules/kubernetes/cluster"
  name             = "sefire-sgp1-dev"
  region_code      = "sgp1"
  resource_version = "1.32.2-do.0"
  size             = local.general_size
  auto_scale       = true
  min_nodes        = 1
  max_nodes        = 5
}