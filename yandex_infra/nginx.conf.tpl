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

    # Docker Registry API должен быть ПЕРЕД основным location
    location ~ ^/v2/(.*) {
        proxy_pass http://${backend_host}:5002/v2/$1$is_args$args;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port $server_port;
        proxy_request_buffering off;
        proxy_buffering off;
        proxy_read_timeout 300;
        proxy_connect_timeout 300;
        proxy_send_timeout 300;

        # Специальные заголовки для Docker Registry
        proxy_set_header Docker-Distribution-Api-Version registry/2.0;
    }

    # Основной веб-интерфейс (должен быть ПОСЛЕ /v2/)
    location / {
        proxy_pass http://${backend_host}:8081;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_request_buffering off;
        proxy_buffering off;
    }
}