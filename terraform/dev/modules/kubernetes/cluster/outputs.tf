#------------
# outputs.tf
#------------

output "kubeconfig" {
  description = "Kubernetes Credentials Output"
  value       = digitalocean_kubernetes_cluster.cluster.kube_config.0.raw_config
  sensitive   = true
}

output "id" {
  description = "Cluster ID Output"
  value       = digitalocean_kubernetes_cluster.cluster.id
  sensitive   = true
}