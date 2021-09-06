######################################
#            create network          #
######################################
resource "google_compute_network" "vpc_network" {
  name = var.gce_network
}

######################################
#            ingress allow           #
######################################
resource "google_compute_firewall" "ingress_allow_internal" {
  name      = "${var.gce_network}-allow-internal"
  network   = google_compute_network.vpc_network.name
  direction = "INGRESS"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.128.0.0/9"]
}

resource "google_compute_firewall" "ingress_allow" {
  name      = "${var.gce_network}-allow"
  network   = google_compute_network.vpc_network.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22", "6443"]
  }

  source_ranges = ["0.0.0.0/0"]
}