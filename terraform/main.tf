provider "google" {
  project = "cloud-1"
  region  = "europe-west1"
}

resource "google_compute_instance" "vm_instance" {
  name         = "wordpress-vm"
  machine_type = "e2-medium"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20220912"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata = {
    ssh-keys = "devuser:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "google_compute_disk" "persistent_disk" {
  name  = "wordpress-disk"
  type  = "pd-standard"
  zone  = "europe-west1-b"
  size  = 50
}
