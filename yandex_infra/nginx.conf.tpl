server {
    listen 80;
    server_name nexus.eqlan.online;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name nexus.eqlan.online;

    ssl_certificate /etc/acme/eqlan.ru_ecc/wildcard.crt;
    ssl_certificate_key /etc/acme/eqlan.ru_ecc/wildcard.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # Увеличиваем размер для Docker образов
    client_max_body_size 0;

    # Docker /v2 requests
    location /v2 {
        proxy_set_header Host $host:$server_port;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto "https";
        proxy_pass http://${backend_host}:8081/repository/docker-hosted$request_uri;
    }

    # Docker /v1 requests
    location /v1 {
        proxy_set_header Host $host:$server_port;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto "https";
        proxy_pass http://${backend_host}:8081/repository/docker-hosted$request_uri;
    }

    # Обычные Nexus запросы (веб-интерфейс)
    location / {
        proxy_set_header Host $host:$server_port;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto "https";
        proxy_pass http://${backend_host}:8081;
    }
}