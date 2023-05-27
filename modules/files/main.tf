# Setup domain Server
resource "google_compute_instance" "server" {
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = var.instance_zone

  metadata = {
    # ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
    enable-oslogin = var.enable_oslogin
    startup-script = file("./modules/files/script.sh")
  }

  tags = var.server_tags

  boot_disk {
    initialize_params {
      image = var.os_image
    }
  }

  connection {
    type        = "ssh"
    host        = self.network_interface[0].network_ip
    user        = var.ssh_posix_user
    private_key = file(var.ssh_key_path)
  }

  network_interface {
    network    = var.vpc_intra_network.self_link
    subnetwork = var.vpc_intra_subnet.self_link
  }
}

## Allow domain Services
resource "google_compute_firewall" "firewall_tcp" {
  name    = var.firewall_rule_name
  network = var.vpc_intra_network.self_link
  allow {
    protocol = var.firewall_rule_protocol
    ports    = var.firewall_rule_ports
  }
  source_ranges = [var.vpc_intra_subnet.ip_cidr_range]
  target_tags   = var.server_tags
}
