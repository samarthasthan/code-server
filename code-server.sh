#!/bin/bash

# Install code-server
curl -fsSL https://code-server.dev/install.sh | sh -s -- --dry-run
curl -fsSL https://code-server.dev/install.sh | sh

# Update and install nginx
sudo apt update
sudo apt install -y nginx

# Update nginx.conf
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
        
        location / {
            proxy_pass http://127.0.0.1:8080;
            proxy_set_header Host \$host;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection upgrade;
            proxy_set_header Accept-Encoding gzip;
        }
    }
}
EOF

# Test nginx configuration
sudo nginx -t

# Restart nginx
sudo systemctl restart nginx

# Configure code-server
sudo mkdir -p /root/.config/code-server/
sudo cat > /root/.config/code-server/config.yaml <<EOF
bind-addr: 127.0.0.1:8080
auth: password
password: Romioisno1.
cert: false
EOF

# Start code-server
screen -S code-server -dm code-server
