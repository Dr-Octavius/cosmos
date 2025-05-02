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
  size_g_4_16 = "g-4vcpu-16gb"
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
  size             = local.size_g_4_16
  auto_scale       = true
  min_nodes        = 1
  max_nodes        = 2
}