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
  project_id              = "{TA_PROJECT}"
  region                  = "{TA_REGION}"
  zone                    = "{TA_ZONE}"
  wordpress_machine_type  = "e2-micro"
  mysql_machine_type      = "e2-micro"
  network_name            = "terraform-network"
}
