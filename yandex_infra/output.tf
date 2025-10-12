output "nexus01" {
  value = yandex_compute_instance.nexus01.network_interface.0.nat_ip_address
}

output "nexus01_internal" {
  value = yandex_compute_instance.nexus01.network_interface.0.ip_address
}

# output "app01" {
#   value       = yandex_compute_instance.app01.network_interface.0.ip_address
# }

output "db01" {
  value       = yandex_compute_instance.db01.network_interface.0.ip_address
}

# output "runner01" {
#   value       = yandex_compute_instance.runner01.network_interface.0.ip_address
# }
