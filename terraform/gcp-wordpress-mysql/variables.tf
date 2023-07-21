variable "credentials_file_path" {
  description = "Path to the GCP service account credentials JSON file."
}

variable "project_id" {
  description = "GCP project ID."
}

variable "region" {
  description = "GCP region for resources."
  default     = "europe-west9"
}

variable "zone" {
  description = "GCP zone for resources."
  default     = "europe-west9-a"
}

variable "wordpress_machine_type" {
  description = "Machine type for the WordPress instance."
  default     = "e2-micro"
}

variable "mysql_machine_type" {
  description = "Machine type for the MySQL instance."
  default     = "e2-micro"
}

variable "network_name" {
  description = "Name of the VPC network."
  default     = "terraform-network"
}
