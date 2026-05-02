#!/bin/bash
set -e

# Update and install dependencies
yum update -y
yum install -y nginx

# Install Node.js 20
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
yum install -y nodejs

# Configure nginx
cat > /etc/nginx/nginx.conf <<'EOF'
events {}
http {
    include /etc/nginx/mime.types;
    server {
        listen 80 default_server;
        root /app/dist;
        index index.html;

        location / {
            try_files $uri $uri/ /index.html;
        }
    }
}
EOF

# Create dist directory and grant ec2-user write access for scp deployments
mkdir -p /app/dist
chown ec2-user:ec2-user /app/dist

systemctl enable nginx
systemctl start nginx
