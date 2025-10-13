resource "yandex_dns_zone" "example_zone" {
  name        = "eqlan-online"
  description = "Public DNS zone for eqlan.online"
  zone        = "eqlan.online."  # обратите внимание на точку в конце
  public      = true
}

resource "yandex_dns_recordset" "nexus" {
  zone_id = yandex_dns_zone.example_zone.id
  name    = "*.eqlan.online."
  type    = "A"
  ttl     = 300
  data =  [yandex_compute_instance.nexus01.network_interface[0].nat_ip_address]
}

