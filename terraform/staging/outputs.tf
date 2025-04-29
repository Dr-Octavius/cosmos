#------------
# outputs.tf
#------------

output "kubeconfig" {
  description = "Kubernetes Credentials Output"
  value       = module.sgp1_cluster.kubeconfig
  sensitive   = true
}