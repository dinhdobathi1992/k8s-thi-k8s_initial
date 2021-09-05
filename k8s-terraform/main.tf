terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("linh-324413-371ec54a7bed.json")

  project = var.gce_project_id
  region  = var.gce_region
  zone    = var.gce_zone
}

# create vm_instance
resource "google_compute_instance" "vm_master" {
  name         = var.vpc-master["name"]
  machine_type = var.vpc-master["machine_type"]
  zone         = var.vpc-master["zone"]

  boot_disk {
    initialize_params {
      image = var.vpc-master["gce_image"]
      size  = var.vpc-master["size_disk"]
    }
  }

  metadata = {
    "ssh-keys" = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

resource "google_compute_instance" "vm_worker" {
  count        = var.instances
  name         = "k8s-worker-${count.index}"
  machine_type = var.vpc-worker["machine_type"]
  zone         = var.vpc-worker["zone"]

  boot_disk {
    initialize_params {
      image = var.vpc-worker["gce_image"]
      size  = var.vpc-worker["size_disk"]
    }
  }

  metadata = {
    "ssh-keys" = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

  depends_on = [
    google_compute_instance.vm_master,
  ]
}