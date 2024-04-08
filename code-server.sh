#!/bin/bash

# Step 1
curl -fsSL https://code-server.dev/install.sh | sh -s -- --dry-run

# Step 2
curl -fsSL https://code-server.dev/install.sh | sh

# Step 3
sudo apt update

# Step 4
sudo apt install nginx

# Step 5: Update nginx.conf
sudo cat > /etc/nginx/nginx.conf <<EOF
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 768;
}

stream {
    upstream ssh {
        server \$(curl -s https://api.ipify.org):22;
    }

    server {
        listen 8022;
        proxy_pass ssh;
    }
}

http {
    server {
        listen 80;
        server_name vscode.samarthasthan.com;
    }
    
    sendfile on;
    tcp_nopush on;
    types_hash_max_size 2048;
    
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    
    gzip on;
    
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
EOF

# Step 6
sudo nginx -t

# Step 7
sudo systemctl restart nginx

# Step 8
sudo cat > /root/.config/code-server/config.yaml <<EOF
bind-addr: 127.0.0.1:8080
auth: password
password: Romioisno1.
cert: false
EOF

# Step 9
screen -S code-server -dm code-server --proxy vscode.samarthasthan.com
