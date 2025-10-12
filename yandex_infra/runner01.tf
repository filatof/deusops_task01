# //
# // Create a new Compute Instance
# //
# resource "yandex_compute_instance" "runner01" {
#   name        = "runner01"
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
#     disk_id = yandex_compute_disk.disk_runner.id
#   }
#
#   network_interface {
#     index     = 1
#     subnet_id = yandex_vpc_subnet.my_subnet.id
#     ip_address = "192.168.10.30"
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
# resource "yandex_compute_image" "ubuntu_2204_runner01" {
#   source_family = "ubuntu-2204-lts"
# }
# # resource "yandex_compute_image" "fedora_37" {
# #   source_family = "fedora-37"
# # }
#
# resource "yandex_compute_disk" "disk_runner" {
#   name     = "boot-disk-runner01"
#   type     = "network-hdd"
#   zone     = "ru-central1-a"
#   size     = "20"
#   image_id = yandex_compute_image.ubuntu_2204_runner01.id
#   labels = {
#     environment = "runner01"
#   }
# }