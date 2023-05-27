# Setup domain Server
resource "google_compute_instance" "server" {
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = var.instance_zone

  metadata = {
    # ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
    enable-oslogin = var.enable_oslogin
    startup-script = file("./modules/http/script.sh")
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
    network    = var.vpc_dmz_network.self_link
    subnetwork = var.vpc_dmz_subnet.self_link
    access_config {
    }
  }
}

## Allow domain Services
resource "google_compute_firewall" "firewall_tcp" {
  name    = var.firewall_rule_name
  network = var.vpc_dmz_network.self_link
  allow {
    protocol = var.firewall_rule_protocol
    ports    = var.firewall_rule_ports
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.server_tags
}


## Allow Health Checks traffic
resource "google_compute_firewall" "firewall_health_check" {
  name    = "http-firewall-health-check"
  network = var.vpc_dmz_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = var.server_tags
}

resource "google_compute_instance_group" "http_instance_group" {
  name        = "http-instance-group"
  network     = var.vpc_dmz_network.self_link
  description = "Instance group for http servers"
  named_port {
    name = "http"
    port = 80
  }
  instances = [
    google_compute_instance.server.self_link
  ]
  depends_on = [google_compute_instance.server]
}
