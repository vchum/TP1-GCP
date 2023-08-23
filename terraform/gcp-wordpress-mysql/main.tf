provider "google" {
  credentials = file(var.credentials_file_path)
  project     = var.project_id
  zone        = var.zone
}

#VPC
resource "google_compute_network" "vpc_network" {
  name = var.network_name
}

#Subnet
resource "google_compute_subnetwork" "tp1_network" {
  name          = "tp1-network"
  network       = google_compute_network.vpc_network.name
  region      = var.region
  ip_cidr_range = "10.0.1.0/24"   
}

#VM Wordpress
resource "google_compute_instance" "vm_instance1" {
  name         = "wordpress"
  machine_type = var.wordpress_machine_type
  tags         = ["wordpress"]
  

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.tp1_network.name
    access_config {              
    }
  }
}

#VM MySQL
resource "google_compute_instance" "vm_instance2" {
  name         = "mysql"
  machine_type = var.mysql_machine_type
  tags         = ["mysql"]
  
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.tp1_network.name
    access_config {              
    } 
  }
}

#Firewall
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name
  
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["wordpress"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_wordpress_mysql" {
  name    = "allow-wordpress-mysql"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges = ["10.0.1.0/24"]
  target_tags = ["mysql", "wordpress"]
}

output "wordpress_instance_ip" {

  value = google_compute_instance.vm_instance1.network_interface[0].access_config[0].nat_ip
  
}

