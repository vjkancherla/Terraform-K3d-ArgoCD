
resource "random_integer" "port" {
  min = 8000
  max = 8099
}

locals {
  host_lb_port = (var.k3d_host_lb_port != null ? var.k3d_host_lb_port : random_integer.port.result)
}

resource "null_resource" "cluster" {
  for_each = toset(var.k3d_cluster_name)
  
  triggers = {
    agent_count  = var.agent_count
    server_count = var.server_count
    ip           = var.k3d_cluster_ip
    port         = var.k3d_cluster_port
    k3s_version  = var.k3s_version
  }
  
  provisioner "local-exec" {
    command = "k3d cluster create ${each.key} --agents ${var.agent_count} --servers ${var.server_count} --api-port ${var.k3d_cluster_ip}:${var.k3d_cluster_port} --port ${local.host_lb_port}:${var.k3d_cluster_lb_port}@loadbalancer --image rancher/k3s:${var.k3s_version} --k3s-node-label 'Infra-Services=true@agent:0' --k3s-node-label 'Infra-Services=true@server:0'"
  }
}

resource "null_resource" "cluster_delete" {
  for_each = toset(var.k3d_cluster_name)

  provisioner "local-exec" {
    command = "k3d cluster delete ${each.key}"
    when    = destroy #the provisioner should only run when the resource is being destroyed.
  }
}