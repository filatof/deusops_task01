//
// Create a new Compute Instance
//
resource "yandex_compute_instance" "nexus01" {
  name        = "nexus01"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    disk_id = yandex_compute_disk.disk_nexus01.id
  }

  network_interface {
    index     = 1
    subnet_id = yandex_vpc_subnet.my_subnet.id
    ip_address = "192.168.10.5"
    nat = true
  }

  metadata = {
    user-data = "${file("metafile.yaml")}"
    serial-port-enable     = "true"
    enable-monitoring-agent = "true"
  }
}
//
// Create a new Compute Disk.
//
resource "yandex_compute_image" "ubuntu_2204_nexus01" {
  source_family = "ubuntu-2204-lts"
}

resource "yandex_compute_disk" "disk_nexus01" {
  name     = "boot-disk-nexus01"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "30"
  image_id = yandex_compute_image.ubuntu_2204_nexus01.id
  labels = {
    environment = "nexus01"
  }
}