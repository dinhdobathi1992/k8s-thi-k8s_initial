variable "gce_region" {
  type    = string
  default = "asia-southeast1"
}
variable "gce_zone" {
  type    = string
  default = "asia-southeast1-b"
}
variable "gce_network" {
  type    = string
  default = "terraform-network"
}

variable "gce_project_id" {
  type        = string
  default     = "linh-324413"
  description = "this is your project id"
}
variable "gce_image" {
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-1804-lts"
  description = "this is os image"
}

variable "vpc-master" {
  description = "Name of VPC"
  type        = map(any)
  default = {
    "name"         = "k8s-master"
    "machine_type" = "e2-medium"
    "zone"         = "asia-southeast1-b"
    "gce_image"    = "ubuntu-os-cloud/ubuntu-1804-lts"
    "size_disk"    = "50"
  }
}

variable "instances" {
  description = "number of ec2 instances"
  default     = 2
}

variable "vpc-worker" {
  description = "Name of VPC worker"
  type        = map(any)
  default = {
    "name"         = "k8s-worker"
    "machine_type" = "e2-medium"
    "zone"         = "asia-southeast1-b"
    "gce_image"    = "ubuntu-os-cloud/ubuntu-1804-lts"
    "size_disk"    = "50"
  }
}

variable "gce_ssh_user" {
  type = string
  default = "linhnh"
  description = "your ssh user"
}
variable "gce_ssh_pub_key_file" {
  default = "~/.ssh/id_rsa.pub"
}

variable "gce_ssh_pvt_key" {
  default = "~/.ssh/id_rsa"
}

# variable "gce_subnetwork" {}

variable "ingress" {
  description = "Configurtion for ingress rule"
  type        = map(any)
  default     = {}
}