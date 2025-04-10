#----------------------
# Variable Definitions
#----------------------
variable "do_token" {
  description = "Digital Ocean API token"
  type        = string
  sensitive   = true
}

#-------------------------------
# Terraform Cloud Configuration
#-------------------------------
terraform {
  cloud {
    organization = "sefire"

    workspaces {
      name = "cosmos-sgp1"
    }
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.50.0"
    }
  }
}

#------------------------
# Provider Configuration
#------------------------
provider "digitalocean" {
  token = var.do_token
}

#------------------------------
# Sefire Cluster Configuration
#------------------------------
resource "digitalocean_kubernetes_cluster" "sefire_sgp1_dev" {
  name    = "sefire-sgp1-dev"
  region  = "sgp1"
  version = "1.30.4-do.0"
  #--------------------------------------
  # To Be Automated via CICD pipeline
  # Include info not in name & dashboard
  # - K8s version
  # - Node Pool Name(s)
  # - Node Pool Owner(s)
  # - Cluster Owner(s)
  # - Compliance (If uniform)
  #--------------------------------------
  tags    = [
    "scribe-np",
    "mesh-np",
    "monitoring-np",
    "networking-np",
    "eck-np",
    "scribe-team",
    "devops-team",
    "pdpa",
  ]

  #------------------------------------------
  # SCRIBE + Fluentd Node Pool Configuration
  #------------------------------------------
  node_pool {
    name       = "scribe-np"
    size       = "s-2vcpu-2gb"
    auto_scale = true
    min_nodes  = 1
    #-------------------------------------------
    # To increase pending Droplet Limit Request
    #-------------------------------------------
    max_nodes  = 2
    labels = {
      nodepool = "scribe-np"
    }
    #--------------------------------------
    # To Be Automated via CICD pipeline
    # Include info not in name & dashboard
    # - Image(s) Deployed
    # - Image Owner
    # - Node Pool Owner
    # - Compliance (If not uniform)
    #--------------------------------------
    tags    = [
      "scribe",
      "scribe-team",
      "devOps-team",
    ]
  }
}

#-------------------------------
# Istio Control Plane Node Pool
#-------------------------------
resource "digitalocean_kubernetes_node_pool" "mesh_np" {
  cluster_id = digitalocean_kubernetes_cluster.lome_sgp1_dev.id
  name       = "mesh-np"
  #-------------------------------------------
  # To decrease pending Droplet Limit Request
  #-------------------------------------------
  size       = "s-4vcpu-8gb"
  auto_scale = true
  min_nodes  = 1
  #----------------------------------------
  # To increase pending node size decrease
  #----------------------------------------
  max_nodes  = 1
  labels = {
    nodepool = "mesh-np"
  }
  #--------------------------------------
  # To Be Automated via CICD pipeline
  # Include info not in name & dashboard
  # - Image(s) Deployed
  # - Image Owner
  # - Node Pool Owner
  # - Compliance (If not uniform)
  #--------------------------------------
  tags    = [
    "istio-base",
    "istio-d",
    "istio-cni",
    "devOps-team",
  ]
}

#-------------------------------
# Istio Control Plane Node Pool
#-------------------------------
resource "digitalocean_kubernetes_node_pool" "monitoring_np" {
  cluster_id = digitalocean_kubernetes_cluster.lome_sgp1_dev.id
  name       = "monitoring-np"
  #-------------------------------------------
  # To decrease pending Droplet Limit Request
  #-------------------------------------------
  size       = "s-4vcpu-8gb"
  auto_scale = true
  min_nodes  = 1
  #----------------------------------------
  # To increase pending node size decrease
  #----------------------------------------
  max_nodes  = 1
  labels = {
    nodepool = "monitoring-np"
  }
  #--------------------------------------
  # To Be Automated via CICD pipeline
  # Include info not in name & dashboard
  # - Image(s) Deployed
  # - Image Owner
  # - Node Pool Owner
  # - Compliance (If not uniform)
  #--------------------------------------
  tags    = [
    "kiali",
    "jaeger",
    "grafana",
    "promethues",
    "devOps-team",
  ]
}

#------------------------------------------------
# Networking Node Pool Configuration
# - Istio Base
# - Istio Ingress Gateway
# - Istio Egress Gateway
# - Istio Ambient Mode Data Plane
# - Metrics Server (for Istio)
#
# Can be separated if necessary depending on use
#------------------------------------------------
resource "digitalocean_kubernetes_node_pool" "networking_np" {
  cluster_id = digitalocean_kubernetes_cluster.lome_sgp1_dev.id
  name       = "networking-np"
  #-------------------------------------------
  # To decrease pending Droplet Limit Request
  #-------------------------------------------
  size       = "s-2vcpu-2gb"
  auto_scale = true
  min_nodes  = 1
  #----------------------------------------
  # To increase pending node size decrease
  #----------------------------------------
  max_nodes  = 2
  labels = {
    nodepool = "networking-np"
  }
  #--------------------------------------
  # To Be Automated via CICD pipeline
  # Include info not in name & dashboard
  # - Image(s) Deployed
  # - Image Owner
  # - Node Pool Owner
  # - Compliance (If not uniform)
  #--------------------------------------
  tags    = [
    "istio-ingress-gateway",
    "istio-egress-gateway",
    "devOps-team",
  ]
}

#---------------------------------------
# Elastic Stack Node Pool Configuration
#---------------------------------------
resource "digitalocean_kubernetes_node_pool" "eck_np" {
  cluster_id = digitalocean_kubernetes_cluster.lome_sgp1_dev.id
  name       = "eck-np"
  #-------------------------------------------
  # To decrease pending Droplet Limit Request
  #-------------------------------------------
  size       = "s-4vcpu-8gb"
  auto_scale = true
  min_nodes  = 1
  #----------------------------------------
  # To increase pending node size decrease
  #----------------------------------------
  max_nodes  = 1
  labels = {
    nodepool = "eck-np"
  }
  #--------------------------------------
  # To Be Automated via CICD pipeline
  # Include info not in name & dashboard
  # - Image(s) Deployed
  # - Image Owner
  # - Node Pool Owner
  # - Compliance (If not uniform)
  #--------------------------------------
  tags    = [
    "elasticsearch",
    "kibana",
    "devOps-team",
  ]
}

#-----------------------------
# LoMe Firewall Configuration
#-----------------------------
resource "digitalocean_firewall" "lome_sgp1_dev_firewall" {
  name = "lome-sgp1-dev-firewall"

  #-----------------------------------
  # To Do Before Release:
  # - Restrict 6443 to trusted IPs
  # (i.e k8s connection with kubectl)
  #-----------------------------------
  inbound_rule {
    protocol         = "tcp"
    port_range       = "6443"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "50051"
    source_addresses = ["192.168.1.1/32", "192.168.10.4/32", "192.168.10.10/32"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "5061"
    source_addresses = ["192.168.1.1/32", "192.168.10.4/32", "192.168.10.10/32"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "9090"
    source_addresses = ["192.168.1.1/32", "192.168.10.4/32", "192.168.10.10/32"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["192.168.1.1/32", "192.168.10.4/32", "192.168.10.10/32"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "8080"
    source_addresses = ["10.104.0.0/20"]  # Allow traffic from all IPs within the VPC
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }

  # Associate with the Kubernetes worker nodes
  #--------------------------------------
  # To Be Automated via CICD pipeline
  # Include info not in name & dashboard
  # - K8s version
  # - Node Pool Name(s)
  # - Node Pool Owner(s)
  # - Cluster Owner(s)
  # - Compliance (If uniform)
  #--------------------------------------
  tags    = [
    "scribe-np",
    "mesh-np",
    "monitoring-np",
    "networking-np",
    "eck-np",
  ]

  depends_on = [
    digitalocean_kubernetes_cluster.lome_sgp1_dev,
    digitalocean_kubernetes_node_pool.mesh_np,
    digitalocean_kubernetes_node_pool.monitoring_np,
    digitalocean_kubernetes_node_pool.networking_np,
    digitalocean_kubernetes_node_pool.eck_np,
  ]
}

#-------------------------------
# Kubernetes Credentials Output
#-------------------------------
output "kubeconfig" {
  value     = digitalocean_kubernetes_cluster.lome_sgp1_dev.kube_config.0.raw_config
  sensitive = true
}
