output "cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "EKS cluster name"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "EKS API server endpoint"
}

output "cluster_ca_certificate" {
  value       = aws_eks_cluster.this.certificate_authority[0].data
  description = "EKS CA certificate"
}

output "kubeconfig" {
  value = {
    cluster_name = aws_eks_cluster.this.name
    endpoint     = aws_eks_cluster.this.endpoint
    certificate  = aws_eks_cluster.this.certificate_authority[0].data
  }
}

output "node_group_name" {
  value = aws_eks_node_group.this.node_group_name
}

