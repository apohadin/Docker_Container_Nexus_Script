provider "google" {
  credentials = file("bionic-aspect-267312-ab0fb5ca396a.json")
  project     = "bionic-aspect-267312"
  region      = "europe-west2"
  zone 	      = "europe-west2-a"
}

resource "google_dns_managed_zone" "private-zone" {
  name        = "private-zone"
  dns_name    = "erichejbest.com."
  description = "Example private DNS zone"
  labels = {
    env = "production"
  }

  visibility = "private"

  }

resource "google_compute_network" "vpc" {
  name          =  "ejbest-prod-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}
resource "google_compute_firewall" "allow-internal" {
  name    = "ejbest-fw-allow-internal"
  network = "${google_compute_network.vpc.name}"
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
  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "allow-http" {
  name    = "ejbest-fw-allow-http"
  network = "${google_compute_network.vpc.name}"
allow {
    protocol = "tcp"
    ports    = ["80", "8081"]
  }
  target_tags = ["http"] 
}
resource "google_compute_firewall" "allow-bastion" {
  name    = "ejbest-fw-allow-bastion"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
  }

resource "google_compute_subnetwork" "main_subnet" {
    name        =   "default-subnet"
    ip_cidr_range   = "10.0.0.0/24"
    network         = "${google_compute_network.vpc.self_link}"
    private_ip_google_access    = true  
}



resource "google_compute_instance" "enterprise" {
  count        = 3  
  name         = "enterprise-${count.index}"
  machine_type = "n1-standard-4"
  min_cpu_platform  = "Intel Skylake"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "50"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    subnetwork       = "${google_compute_subnetwork.main_subnet.self_link}"
    access_config {
    }
  }

  metadata = {
    sshKeys = "mydeployuser:${file("mydeployuser.pub")}"
  }

 metadata_startup_script = "sudo yum install httpd -y;sudo hostnamectl set-hostname enterprise1.erich.com;useradd -d /home/mydeployuser mydeployuser"

}


resource "google_compute_instance" "target" {
  count        = 5  
  name         = "target-${count.index}"
  machine_type = "n1-standard-1"
  min_cpu_platform  = "Intel Skylake"
  allow_stopping_for_update = true
  
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "50"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    subnetwork       = "${google_compute_subnetwork.main_subnet.self_link}"
    access_config {
    }
  }

  metadata = {
    sshKeys = "mydeployuser:${file("mydeployuser.pub")}"
  }

  provisioner "file" {
  source = "./mrclean.sh"
  destination = "~/mrclean.sh"

  connection {
      type        = "ssh"
      host        = self.network_interface[0].access_config[0].nat_ip
      user        = "neil"
      timeout     = "500s"
      private_key = "${file("~/.ssh/mydeployuser")}"

  }
}

  metadata_startup_script = "sudo yum install httpd -y;sudo yum remove docker-ce* -y;sudo yum install docker -y;sudo curl -fsSL https://get.docker.com/ | sh;sudo systemctl start docker;sudo systemctl status docker;sudo systemctl enable docker;sudo hostnamectl set-hostname target-${count.index}.erich.com;useradd -d /home/mydeployuser mydeployuser"

  
}
