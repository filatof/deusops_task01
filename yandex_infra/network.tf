//
// Create a new VPC Network.
//
resource "yandex_vpc_network" "network" {
  name = "task1"
}

resource "yandex_vpc_subnet" "my_subnet" {
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  route_table_id = yandex_vpc_route_table.my_table.id
}
