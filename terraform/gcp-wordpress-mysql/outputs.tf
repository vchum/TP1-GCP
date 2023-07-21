output "wordpress_instance_ip" {
  description = "Public IP address of the WordPress instance."
  value       = google_compute_instance.vm_instance1.network_interface.0.access_config.0.nat_ip
}

output "mysql_instance_ip" {
  description = "Public IP address of the MySQL instance."
  value       = google_compute_instance.vm_instance2.network_interface.0.access_config.0.nat_ip
}