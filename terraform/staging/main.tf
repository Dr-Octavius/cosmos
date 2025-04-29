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

#----------------------
# Referenced Configs
# - module blocks only
#----------------------
# Sefire Staging Environment using DOKS
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

# Module Config for dedicated Prometheus nodepool
module "prometheus_np" {
  source     = "./modules/kubernetes/nodepool"
  cluster_id = module.sgp1_cluster.id
  name       = "prometheus-np"
  size       = local.medium_size
  auto_scale = true
  min_nodes  = 1
  max_nodes  = 3
  depends_on = [module.sgp1_cluster]
}

# Module Config for dedicated Jaeger nodepool
module "jaeger_np" {
  source     = "./modules/kubernetes/nodepool"
  cluster_id = module.sgp1_cluster.id
  name       = "jaeger-np"
  size       = local.medium_size
  auto_scale = true
  min_nodes  = 1
  max_nodes  = 3
  depends_on = [module.sgp1_cluster]
}

# Module Config for dedicated Elasticsearch nodepool
module "elasticsearch_np" {
  source     = "./modules/kubernetes/nodepool"
  cluster_id = module.sgp1_cluster.id
  name       = "elasticsearch-np"
  size       = local.general_size
  auto_scale = true
  min_nodes  = 1
  max_nodes  = 3
  depends_on = [module.sgp1_cluster]
}

# Module Config for Sefire Firewall
module "sefire_sgp1_dev_firewall" {
  source = "./modules/firewall"
  name   = "sefire-sgp1-dev-firewall"
  inbound_rules = [
    {
      protocol         = "tcp"
      port_range       = "6443"
      source_addresses = ["0.0.0.0/0"] #  To Restrict 6443 to trusted IPs in Prod
    },
    {
      protocol         = "tcp"
      port_range       = "50051"
      source_addresses = ["192.168.1.1/32", "192.168.10.4/32", "192.168.10.10/32"]
    },
    {
      protocol         = "tcp"
      port_range       = "5061"
      source_addresses = ["192.168.1.1/32", "192.168.10.4/32", "192.168.10.10/32"]
    },
    {
      protocol         = "tcp"
      port_range       = "9090"
      source_addresses = ["192.168.1.1/32", "192.168.10.4/32", "192.168.10.10/32"]
    },
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["192.168.1.1/32", "192.168.10.4/32", "192.168.10.10/32"]
    },
    {
      protocol         = "tcp"
      port_range       = "8080"
      source_addresses = ["10.104.0.0/20"] # Allow traffic from all IPs within the VPC
    }
  ]
  outbound_rules = [
    {
      protocol              = "tcp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0"]
    }
  ]
  depends_on = [module.sgp1_cluster]
}