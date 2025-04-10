# Query xsmall instance size
data "civo_size" "xsmall" {
  filter {
    key = "type"
    values = ["kubernetes"]
  }

  sort {
    key = "ram"
    direction = "asc"
  }
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
    civo = {
      source = "civo/civo"
      version = "1.1.5"
    }
  }
}

#------------------------
# Provider Configuration
#------------------------
provider "civo" {
  // credentials_file = "/secure/path/civo.json"
  region = "LON1"
}

# Create a firewall
resource "civo_firewall" "sefire_firewall" {
  name = "scribe-firewall"
  create_default_rules = false

  ingress_rule {
    label      = "gRPC"
    protocol   = "tcp"
    port_range = "50051"
    cidr       = ["192.168.1.1/32", "192.168.10.4/32", "192.168.10.10/32"]
    action     = "allow"
  }

  ingress_rule {
    label      = "HTTP"
    protocol   = "tcp"
    port_range = "9090"
    cidr       = ["192.168.1.1/32", "192.168.10.4/32", "192.168.10.10/32"]
    action     = "allow"
  }

  ingress_rule {
    label      = "SSH"
    protocol   = "tcp"
    port_range = "22"
    cidr       = ["192.168.1.1/32", "192.168.10.4/32", "192.168.10.10/32"]
    action     = "allow"
  }

  egress_rule {
    label      = "all"
    protocol   = "tcp"
    port_range = "1-65535"
    cidr       = ["0.0.0.0/0"]
    action     = "allow"
  }
}

# Create a cluster with k3s
resource "civo_kubernetes_cluster" "sefire_cluster" {
  name = "scribe-cluster"
  applications = "Prometheus,Portainer,Linkerd:Linkerd & Jaeger,Grafana"
  firewall_id = civo_firewall.sefire_firewall
  cluster_type = "k3s"
  pools {
    label = "front-end" // Optional
    size = element(data.civo_size.xsmall.sizes, 0).name
    node_count = 3
  }
}