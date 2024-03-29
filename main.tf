resource "ibm_container_cluster" "kubecluster" {
  name              = "${var.cluster_name}${random_id.name.hex}"
  datacenter        = "${var.datacenter}"
  default_pool_size = "${var.default_pool_size}"
  machine_type      = "${var.machine_type}"
  hardware          = "${var.hardware}"
  kube_version      = "${var.kube_version}"
  public_vlan_id    = "${var.public_vlan_id}"
  private_vlan_id   = "${var.private_vlan_id}"
  lifecycle {
    ignore_changes = ["kube_version"]
  }
}

resource "random_id" "name" {
  byte_length = 4
}

provider "helm" {
  kubernetes {
    config_path = "${data.ibm_container_cluster_config.cluster_config.config_file_path}"
  }
}

resource "helm_chart" "myredis" {
   depends_on = ["ibm_container_cluster.kubecluster"]
   name      = "my_redis"
   chart     = "stable/redis"
}
