# Wait until EKS private node group joins the cluster
resource "null_resource" "wait_nodes_join_cluster" {
  depends_on = [aws_eks_node_group.demo_private]

  triggers = {
    build_number = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOS
      for i in `seq 1 60`; do \
      terraform output kubeconfig > kube_file && \
      kubectl get nodes --kubeconfig kube_file | grep -q ' Ready' && break || \
      sleep 10; \
      done
    EOS
  }
}

# Wait until configmap for node auth is applied
resource "null_resource" "wait_nodes_join_cluster_apply_configmap_connecting_node" {
  depends_on = [null_resource.wait_nodes_join_cluster]

  triggers = {
    build_number = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOS
      for i in `seq 1 60`; do \
      kubectl create ns app --kubeconfig kube_file || true; \
      terraform output config_map_aws_auth > configmap.yaml && \
      kubectl apply -f configmap.yaml --kubeconfig kube_file | grep -q 'configmap/aws-auth' && break || \
      sleep 10; \
      done
    EOS
  }
}

# Install Metrics Server using Helm
resource "helm_release" "metrics_server" {
  depends_on = [null_resource.wait_nodes_join_cluster_apply_configmap_connecting_node]
  name       = "metrics-server"
  repository = "https://charts.helm.sh/stable"
  chart      = "metrics-server"
  namespace  = "kube-system"

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "hostNetwork.enabled"
    value = "true"
  }

  set {
    name  = "args"
    value = "{--v=2,--kubelet-preferred-address-types=InternalIP,--kubelet-insecure-tls}"
  }
}

# Install Nginx Ingress using Helm
resource "helm_release" "nginx_ingress" {
  depends_on = [helm_release.metrics_server]
  name       = "nginx-ingress"
  repository = "https://charts.helm.sh/stable"
  chart      = "nginx-ingress"
  version    = "1.33.0"
  namespace  = var.namespace

  set {
    name  = "controller.service.loadBalancerSourceRanges"
    value = "{${join(",", var.external_ip_addr_cidrs)}}"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-security-groups"
    value = aws_security_group.demo-cluster.id
  }
}

# Deploy Node.js application via kubectl
resource "null_resource" "deploy-application-node-js" {
  depends_on = [helm_release.nginx_ingress]

  triggers = {
    build_number = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOS
      for i in `seq 1 60`; do \
      kubectl apply -f deployment_yaml/ --kubeconfig kube_file | grep -q 'service/node-js' && break || \
      sleep 10; \
      done
    EOS
  }
}
