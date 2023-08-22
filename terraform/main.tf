terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.74.0"
    }
  }
}

provider "google" {
  credentials = file("../service_account.json")
}

module "gcp_wordpress_mysql" {
  source                  = "./gcp-wordpress-mysql"
  credentials_file_path   = "../service_account.json"
  project_id              = "quiet-vector-393409"
  region                  = "europe-west9"
  zone                    = "europe-west9-a"
  wordpress_machine_type  = "e2-micro"
  mysql_machine_type      = "e2-micro"
  network_name            = "terraform-network"
}
