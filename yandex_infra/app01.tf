# //
# // Create a new Compute Instance
# //
# resource "yandex_compute_instance" "app01" {
#   name        = "app01"
#   platform_id = "standard-v3"
#   zone        = "ru-central1-a"
#
#   resources {
#     cores  = 2
#     memory = 2
#     core_fraction = 20
#   }
#
#   boot_disk {
#     disk_id = yandex_compute_disk.disk_app01.id
#   }
#
#   network_interface {
#     index     = 1
#     subnet_id = yandex_vpc_subnet.my_subnet.id
#     ip_address = "192.168.10.20"
#   }
#
#   metadata = {
#     user-data = "${file("metafile.yaml")}"
#     serial-port-enable     = "true"
#     enable-monitoring-agent = "true"
#   }
# }
#
# //
# // Create a new Compute Disk.
# //
# # resource "yandex_compute_image" "ubuntu_2204_app01" {
# #   source_family = "ubuntu-2204-lts"
# # }
# resource "yandex_compute_image" "debian_12" {
#   source_family = "debian-12"
# }
#
# resource "yandex_compute_disk" "disk_app01" {
#   name     = "boot-disk-app01"
#   type     = "network-hdd"
#   zone     = "ru-central1-a"
#   size     = "10"
#   image_id = yandex_compute_image.debian_12.id
#   labels = {
#     environment = "app01"
#   }
# }