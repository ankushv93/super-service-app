#
# Outputs
#

locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.demo-node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.demo.endpoint}
    certificate-authority-data: ${aws_eks_cluster.demo.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster-name}"
KUBECONFIG
}

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

output "kubeconfig" {
  value = local.kubeconfig
}

output "vpc_id" {
  value       = module.networking.vpc_id
  description = "Present VPC id info"
}

output "vpc_cidr" {
  value       = module.networking.vpc_cidr
  description = "Present cidr blocks"
}

output "vpc_route_table_ids" {
  value       = module.networking.vpc_route_table_ids
  description = "Present route tables ids"
}

output "cluster_security_group_id" {
  value       = aws_security_group.demo-cluster.id
  description = "Cluster SG id"
}

output "private_subnet_ids" {
  value       = module.networking.private_subnet_ids
  description = "Present private subnet ids"
}

output "public_subnet_ids" {
  value       = module.networking.public_subnet_ids
  description = "Present public subnet ids"
}