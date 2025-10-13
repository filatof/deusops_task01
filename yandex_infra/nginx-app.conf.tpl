server {
    listen 80;
    server_name app.eqlan.online;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name app.eqlan.online;

    ssl_certificate /etc/acme/eqlan.ru_ecc/wildcard.crt;
    ssl_certificate_key /etc/acme/eqlan.ru_ecc/wildcard.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # Увеличиваем размер для Docker образов
    client_max_body_size 0;


    location / {
        proxy_pass http://${backend_host_app}:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_request_buffering off;
        proxy_buffering off;
    }
}