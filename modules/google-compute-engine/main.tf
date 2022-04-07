resource "random_string" "project_suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "google_project" "new_project" {
  count               = var.create_project ? 1 : 0
  name                = format("%s-%s", var.project_name, random_string.project_suffix.result)
  project_id          = format("%s-%s", var.project_name, random_string.project_suffix.result)
  org_id              = var.organization_id
  billing_account     = var.gcp_billing_account
  auto_create_network = false
}

locals {
  os_image_ubuntu   = var.operating_system == "ubuntu_20_04" ? "ubuntu-os-cloud/ubuntu-2004-lts" : ""
  os_image_rhel     = var.operating_system == "rhel_8" ? "rhel-cloud/rhel-8" : ""
  os_image          = coalesce(local.os_image_ubuntu, local.os_image_rhel)
  project_id        = var.create_project ? google_project.new_project.0.project_id : var.project_id
  username          = "gpc"
  root_disk_size    = 500
  add_on_disk_count = 1
  add_on_disk_size  = 1024
}

resource "google_project_service" "compute_engine" {
  project            = local.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_network" "gpc_network" {
  depends_on = [
    google_project_service.compute_engine
  ]
  project                 = local.project_id
  name                    = "gpc-network"
  auto_create_subnetworks = true
  mtu                     = 1500
}

resource "google_compute_firewall" "allow-all-internal" {
  name      = format("%s-%s", google_compute_network.gpc_network.name, "allow-all-internal")
  project   = local.project_id
  network   = google_compute_network.gpc_network.id
  priority  = 65534
  direction = "INGRESS"
  allow {
    protocol = "all"
  }
  source_ranges = ["10.128.0.0/9"]
  target_tags   = ["bastion", "node"]
}

resource "google_compute_firewall" "allow-icmp" {
  name      = format("%s-%s", google_compute_network.gpc_network.name, "allow-icmp")
  project   = local.project_id
  network   = google_compute_network.gpc_network.id
  priority  = 65534
  direction = "INGRESS"
  allow {
    protocol = "icmp"
  }
  target_tags   = ["bastion"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-ssh" {
  name      = format("%s-%s", google_compute_network.gpc_network.name, "allow-ssh")
  project   = local.project_id
  network   = google_compute_network.gpc_network.id
  priority  = 65534
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = ["bastion"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "bastion_ip" {
  depends_on = [
    google_project_service.compute_engine
  ]
  name    = "bastion-ip"
  project = local.project_id
  region  = trim(var.gcp_zone, "-a")
}

resource "google_compute_project_metadata" "ssh_pub_key" {
  depends_on = [
    google_project_service.compute_engine
  ]
  project = local.project_id
  metadata = {
    ssh-keys = <<EOF
      ${local.username}:${var.ssh_key.public_key}
    EOF
  }
}

resource "google_compute_disk" "default" {
  count = var.worker_node_count * local.add_on_disk_count
  depends_on = [
    google_project_service.compute_engine
  ]
  project = local.project_id
  name    = format("disk-%02d", count.index + 1)
  type    = "pd-ssd"
  zone    = var.gcp_zone
  size    = local.add_on_disk_size
}

resource "google_compute_instance" "cp_node" {
  count = var.cp_node_count
  depends_on = [
    google_project_service.compute_engine
  ]
  project      = local.project_id
  name         = format("%s-cp-%02d", var.cluster_name, count.index + 1)
  machine_type = var.gcp_cp_instance_type
  zone         = var.gcp_zone
  tags         = [count.index == 0 ? "bastion" : "node"]
  labels       = { "anthos" = "private_mode" }
  boot_disk {
    initialize_params {
      image = local.os_image
      size  = local.root_disk_size
      type  = "pd-ssd"
    }
  }
  network_interface {
    network = google_compute_network.gpc_network.id
    access_config {
      nat_ip = count.index == 0 ? google_compute_address.bastion_ip.address : null
    }
  }
}

resource "google_compute_instance" "worker_node" {
  count = var.worker_node_count
  depends_on = [
    google_project_service.compute_engine
  ]
  project      = local.project_id
  name         = format("%s-worker-%02d", var.cluster_name, count.index + 1)
  machine_type = var.gcp_worker_instance_type
  zone         = var.gcp_zone
  tags         = [count.index == 0 ? "bastion" : "node"]
  labels       = { "anthos" = "private_mode" }
  boot_disk {
    initialize_params {
      image = local.os_image
      size  = 150 # This size is for IO performance, we really only need 150GB
      type  = "pd-ssd"
    }
  }
  network_interface {
    network = google_compute_network.gpc_network.id
  }
}

resource "google_compute_attached_disk" "default" {
  count    = length(google_compute_disk.default)
  disk     = element(google_compute_disk.default.*.id, count.index)
  instance = element(google_compute_instance.cp_node.*.id, floor((count.index / var.worker_node_count) + 4)) # Test for +4
}

data "template_file" "cp_node_networking" {
  count    = var.cp_node_count
  template = file("${path.module}/templates/node_networking.py")
  vars = {
    local_ip             = element(google_compute_instance.cp_node.*.network_interface.0.network_ip, count.index)
    gre_ip_cidr          = format("%s/%s", cidrhost(var.private_subnet, count.index + 1), split("/", var.private_subnet).1)
    cp_local_ip_list     = jsonencode(google_compute_instance.cp_node.*.network_interface.0.network_ip)
    worker_local_ip_list = jsonencode(google_compute_instance.worker_node.*.network_interface.0.network_ip)
    gre_cidr             = var.private_subnet
  }
}

data "template_file" "worker_node_networking" {
  count    = var.worker_node_count
  template = file("${path.module}/templates/node_networking.py")
  vars = {
    local_ip             = element(google_compute_instance.worker_node.*.network_interface.0.network_ip, count.index)
    gre_ip_cidr          = format("%s/%s", cidrhost(var.private_subnet, count.index + 4), split("/", var.private_subnet).1)
    cp_local_ip_list     = jsonencode(google_compute_instance.cp_node.*.network_interface.0.network_ip)
    worker_local_ip_list = jsonencode(google_compute_instance.worker_node.*.network_interface.0.network_ip)
    gre_cidr             = var.private_subnet
  }
}

resource "null_resource" "cp_node_networking" {
  count = var.cp_node_count
  connection {
    type         = "ssh"
    user         = local.username
    private_key  = var.ssh_key.private_key
    bastion_host = google_compute_address.bastion_ip.address
    host         = element(google_compute_instance.cp_node.*.network_interface.0.network_ip, count.index)
  }

  provisioner "remote-exec" {
    inline = ["mkdir -p $HOME/bootstrap/"]
  }

  provisioner "file" {
    content     = element(data.template_file.cp_node_networking.*.rendered, count.index)
    destination = "$HOME/bootstrap/node_networking.py"
  }

  provisioner "remote-exec" {
    inline = ["python3 $HOME/bootstrap/node_networking.py"]
  }
}

resource "null_resource" "worker_node_networking" {
  count = var.worker_node_count
  connection {
    type         = "ssh"
    user         = local.username
    private_key  = var.ssh_key.private_key
    bastion_host = google_compute_address.bastion_ip.address
    host         = element(google_compute_instance.worker_node.*.network_interface.0.network_ip, count.index)
  }

  provisioner "remote-exec" {
    inline = ["mkdir -p $HOME/bootstrap/"]
  }

  provisioner "file" {
    content     = element(data.template_file.worker_node_networking.*.rendered, count.index)
    destination = "$HOME/bootstrap/node_networking.py"
  }

  provisioner "remote-exec" {
    inline = ["python3 $HOME/bootstrap/node_networking.py"]
  }
}

resource "google_compute_router" "cloud-router" {
  name    = format("%s-router", var.cluster_name)
  region  = trim(var.gcp_zone, "-a")
  network = google_compute_network.gpc_network.id
  project = local.project_id
  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat-gateway" {
  name                               = format("%s-net-gateway", var.cluster_name)
  router                             = google_compute_router.cloud-router.name
  region                             = google_compute_router.cloud-router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  project                            = local.project_id

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
