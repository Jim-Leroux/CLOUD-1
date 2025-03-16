provider "google" {
  project = var.gcp_project_id
  region  = "europe-west1"
}

resource "google_compute_instance" "vm_instance" {
  name         = "wordpress-vm"
  machine_type = "e2-medium"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20250313"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "devuser:${file("~/.ssh/id_rsa.pub")}"
  }

  # Transfert du fichier docker-compose.yml sur la VM
  provisioner "file" {
    source      = "../docker-compose.yml"
    destination = "/home/devuser/docker-compose.yml"
    connection {
      type        = "ssh"
      user        = "devuser"
      private_key = file("~/.ssh/id_rsa")
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }

  # Transfert du playbook Ansible sur la VM
  provisioner "file" {
    source      = "../ansible/playbook.yml"
    destination = "/home/devuser/playbook.yml"
    connection {
      type        = "ssh"
      user        = "devuser"
      private_key = file("~/.ssh/id_rsa")
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }

  # Installation des outils nécessaires via apt
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y software-properties-common",
      "sudo apt install -y python3 python3-pip ansible docker.io docker-compose"
    ]
    connection {
      type        = "ssh"
      user        = "devuser"
      private_key = file("~/.ssh/id_rsa")
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }

  # Exécution du playbook Ansible pour démarrer les containers
  provisioner "remote-exec" {
    inline = [
      "ansible-playbook /home/devuser/playbook.yml"
    ]
    connection {
      type        = "ssh"
      user        = "devuser"
      private_key = file("~/.ssh/id_rsa")
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }
}

