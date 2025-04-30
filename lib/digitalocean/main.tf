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
  size_1_2 = "s-1vcpu-2gb"
  size_2_2 = "s-2vcpu-2gb"
  size_1_3 = "s-1vcpu-3gb"
  size_2_4 = "s-2vcpu-4gb"
  size_c2 = "c-2"
  size_4_8 = "s-4vcpu-8gb"
  size_g_2_8 = "g-2vcpu-8gb"
  size_gd_2_8 = "gd-2vcpu-8gb"
  size_c4 = "c-4"
  size_6_16= "s-6vcpu-16gb"
  size_g_4_16 = "g-4vcpu-16gb"
  size_gd_4_16 = "gd-4vcpu-16gb"
  size_c8 = "c-8"
  size_8_32= "s-8vcpu-32gb"
  size_g_8_32 = "g-8vcpu-32gb"
  size_gd_8_32 = "gd-8vcpu-32gb"
  size_c16 = "c-16"
  size_12_48= "s-12vcpu-48gb"
  size_16_64= "s-16vcpu-64gb"
  size_g_16_64 = "g-16vcpu-64gb"
  size_gd_16_64 = "gd-16vcpu-64gb"
  size_c32 = "c-32"
  size_20_96= "s-20vcpu-96gb"
  size_24_128= "s-24vcpu-128gb"
  size_g_32_128 = "g-32vcpu-128gb"
  size_gd_32_128 = "gd-32vcpu-128gb"
  size_g_40_160 = "g-40vcpu-160gb"
  size_gd_40_160 = "gd-40vcpu-160gb"
  size_32_192= "s-32vcpu-192gb"
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
  max_nodes        = 5
}