provider "google" {
  credentials = file("fiery-azimuth-267318-5236761af7a8.json")
  project     = "fiery-azimuth-267318"
  region      = "asia-east1"
  zone 	      = "asia-east1-a"
}

resource "google_dns_managed_zone" "private-zone" {
  name        = "private-zone"
  dns_name    = "maplequad.com."
  description = "Example private DNS zone"
  labels = {
    foo = "bar"
  }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.network-1.self_link
    }
    networks {
      network_url = google_compute_network.network-2.self_link
    }
  }
}

resource "google_compute_network" "network-1" {
  name                    = "network-1"
  auto_create_subnetworks = false
}

resource "google_compute_network" "network-2" {
  name                    = "network-2"
  auto_create_subnetworks = false
}

resource "google_compute_instance" "enterprise1" {
  name         = "enterprise1"
  machine_type = "e2-standard-8"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "50"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config {
    }
  }

 metadata_startup_script = "sudo yum install httpd -y;sudo hostnamectl set-hostname enterprise1.maplequad.com;useradd -d /home/mydeployuser mydeployuser"

}


resource "google_compute_instance" "enterprise2" {
  name         = "enterprise2"
  machine_type = "e2-standard-8"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "50"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config {
    }
  }

  metadata_startup_script = "sudo yum install httpd -y;sudo hostnamectl set-hostname enterprise2.maplequad.com;useradd -d /home/mydeployuser mydeployuser"
}

resource "google_compute_instance" "enterprise3" {
  name         = "enterprise3"
  machine_type = "e2-standard-8"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "50"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config {
    }
  }




}


resource "google_compute_instance" "target1" {
  name         = "target1"
  machine_type = "n1-standard-1"
  zone  = "asia-east2-b"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "50"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config {
    }
  }

  metadata_startup_script = "sudo yum install httpd -y;sudo hostnamectl set-hostname target1.maplequad.com;useradd -d /home/mydeployuser mydeployuser"

}

resource "google_compute_instance" "target2" {
  name         = "target2"
  machine_type = "n1-standard-1"
  zone  = "asia-east2-c"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "50"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config {
    }
  }

  metadata_startup_script = "sudo yum install httpd -y;sudo hostnamectl set-hostname target2.maplequad.com;useradd -d /home/mydeployuser mydeployuser"

}

resource "google_compute_instance" "target3" {
  name         = "target3"
  machine_type = "n1-standard-1"
  zone  = "asia-east2-c"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "50"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config {
    }
  }

  metadata = {
    sshKeys = "neil:${file("id_rsa.pub")}"
  }

  provisioner "file" {
  source = "./mrclean.sh"
  destination = "~/mrclean.sh"

  connection {
      type        = "ssh"
      host        = self.network_interface[0].access_config[0].nat_ip
      user        = "neil"
      timeout     = "500s"
      private_key = "${file("~/.ssh/id_rsa")}"

  }
}


  metadata_startup_script = "sudo yum install httpd -y;sudo hostnamectl set-hostname enterprise3.maplequad.com;useradd -d /home/mydeployuser mydeployuser;sudo yum install httpd -y;sudo yum remove docker-ce* -y;sudo yum install docker -y;sudo curl -fsSL https://get.docker.com/ | sh;sudo systemctl start docker;sudo systemctl status docker;sudo systemctl enable docker"

}

resource "google_compute_instance" "target4" {
  name         = "target4"
  machine_type = "n1-standard-1"
  zone  = "asia-east2-b"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "50"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config {
    }
  }

  metadata = {
    sshKeys = "neil:${file("id_rsa.pub")}"
  }

  provisioner "file" {
  source = "./mrclean.sh"
  destination = "~/mrclean.sh"

  connection {
      type        = "ssh"
      host        = self.network_interface[0].access_config[0].nat_ip
      user        = "neil"
      timeout     = "500s"
      private_key = "${file("~/.ssh/id_rsa")}"

  }
}


  metadata_startup_script = "sudo yum install httpd -y;sudo hostnamectl set-hostname target4.maplequad.com;useradd -d /home/mydeployuser mydeployuser;sudo yum install httpd -y;sudo yum remove docker-ce* -y;sudo yum install docker -y;sudo curl -fsSL https://get.docker.com/ | sh;sudo systemctl start docker;sudo systemctl status docker;sudo systemctl enable docker"

}


resource "google_compute_instance" "target5" {
  name         = "target5"
  machine_type = "n1-standard-1"
  zone  = "asia-east2-c"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "50"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config {
    }
  }

  metadata = {
    sshKeys = "neil:${file("id_rsa.pub")}"
  }

  provisioner "file" {
  source = "./mrclean.sh"
  destination = "~/mrclean.sh"

  connection {
      type        = "ssh"
      host        = self.network_interface[0].access_config[0].nat_ip
      user        = "neil"
      timeout     = "500s"
      private_key = "${file("~/.ssh/id_rsa")}"

  }
}


  metadata_startup_script = "sudo yum install httpd -y;sudo hostnamectl set-hostname target5.maplequad.com;useradd -d /home/mydeployuser mydeployuser;sudo yum install httpd -y;sudo yum remove docker-ce* -y;sudo yum install docker -y;sudo curl -fsSL https://get.docker.com/ | sh;sudo systemctl start docker;sudo systemctl status docker;sudo systemctl enable docker"

}
