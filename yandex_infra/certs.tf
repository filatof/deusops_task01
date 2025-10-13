# resource "yandex_cm_certificate" "wildcard_cert" {
#   name        = "wildcard-eqlan-cert"
#   description = "Self-signed wildcard certificate for *.eqlan.online"
#
#   self_managed {
#     certificate = file("${path.module}/certs/wildcard.crt")
#     private_key = file("${path.module}/certs/wildcard.key")
#   }
# }

# wildcard letsencrypt
resource "yandex_cm_certificate" "wildcard_cert" {
  name    = "wildcard-eqlan-online-cert"
  domains = ["*.eqlan.online", "eqlan.online"]

  managed {
    challenge_type = "DNS_CNAME"
  }
}

data "yandex_cm_certificate_content" "wildcard_cert_content" {
  certificate_id = yandex_cm_certificate.wildcard_cert.id

  depends_on = [yandex_cm_certificate.wildcard_cert]
}


# 5. Подготовка конфигурации Nginx
locals {
    nginx_config = templatefile("${path.module}/nginx.conf.tpl", {
    backend_host = "192.168.10.5"
  })
}

locals {
    nginx_config_app = templatefile("${path.module}/nginx-app.conf.tpl", {
    backend_host_app = "192.168.10.20"
  })
}

# cloud-init конфигурация (используем данные из Certificate Manager)
locals {
    cloud_init_config = templatefile("${path.module}/cloud-init.yaml", {
    nginx_config_app = base64encode(local.nginx_config_app)
    nginx_config    = base64encode(local.nginx_config)
    ssl_certificate = base64encode(join("\n", data.yandex_cm_certificate_content.wildcard_cert_content.certificates))
    ssl_key         = base64encode(data.yandex_cm_certificate_content.wildcard_cert_content.private_key)
  })
}
