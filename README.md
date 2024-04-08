Certainly, here's the updated markdown file with instructions to replace the placeholder with the actual IPv4 address:

````markdown
# Server Setup Script

This script automates the setup process for code-server and nginx on a VPS.

## Instructions

1. SSH into your VPS.

   ```bash
   ssh your_username@your_server_ip
   ```
````

2. Clone the repository.

   ```bash
   git clone https://github.com/samarthasthan/code-server.git
   ```

3. Navigate to the directory.

   ```bash
   cd code-server
   ```

4. Grant execute permission.

   ```bash
   chmod +x code-server.sh
   ```

5. **Replace placeholder with actual IPv4 address**: In the script, replace `ipv4:22` in the `stream` block with your VPS's actual IPv4 address.

6. Run the script.

   ```bash
   ./code-server.sh
   ```

7. Follow the prompts during the execution.

## Script

```bash
#!/bin/bash

# Install code-server
curl -fsSL https://code-server.dev/install.sh | sh -s -- --dry-run
curl -fsSL https://code-server.dev/install.sh | sh

# Update and install nginx
sudo apt update
sudo apt install -y nginx

# Replace 'ipv4:22' with your VPS's actual IPv4 address here
ipv4_address="$(curl -s https://api.ipify.org)"
sed -i "s/ipv4:22/$ipv4_address:22/g" /etc/nginx/nginx.conf

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
        server $ipv4_address:22;
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
```

Make sure to replace `ipv4:22` in the script with your VPS's actual IPv4 address before running it. Also, review and customize the script according to your requirements.

```

```
