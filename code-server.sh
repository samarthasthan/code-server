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
        server localhost:22;
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

sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt-get update
sudo apt-get install -y golang-go 

sudo apt install -y protobuf-compiler

wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install node
sudo apt install -y npm

go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

export PATH="$PATH:$(go env GOPATH)/bin"

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" 
apt-cache policy docker-ce
sudo apt install -y docker-ce 

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

sudo apt install -y clang-format

curl -L https://packagecloud.io/golang-migrate/migrate/gpgkey | apt-key add -
echo "deb https://packagecloud.io/golang-migrate/migrate/ubuntu/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/migrate.list
apt-get update
apt-get install -y migrate


go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest

# install migrate 
curl -s https://packagecloud.io/install/repositories/golang-migrate/migrate/script.deb.sh | sudo bash
sudo apt-get update
sudo apt-get install migrate

# Start code-server
screen -S code-server -dm code-server --proxy-domain vscode.samarthasthan.com
