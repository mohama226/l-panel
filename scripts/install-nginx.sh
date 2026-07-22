#!/usr/bin/env bash

set -Eeuo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

NGINX_CONF_DIR="/etc/nginx/conf.d"
NGINX_CONF_FILE="$NGINX_CONF_DIR/l-panel.conf"

FRONTEND_DIST="$BASE_DIR/frontend/dist"

echo "=================================="
echo " Installing Nginx"
echo "=================================="


if command -v dnf >/dev/null 2>&1; then

    dnf install -y nginx

elif command -v yum >/dev/null 2>&1; then

    yum install -y nginx

elif command -v apt >/dev/null 2>&1; then

    apt update
    apt install -y nginx

else

    echo "Unsupported operating system."
    exit 1

fi


systemctl enable nginx


systemctl start nginx || true


mkdir -p "$NGINX_CONF_DIR"


cat > "$NGINX_CONF_FILE" <<EOF
server {

    listen 80;

    server_name _;


    root $FRONTEND_DIST;

    index index.html;


    location / {

        try_files \$uri \$uri/ /index.html;

    }


    location /api/ {

        proxy_pass http://127.0.0.1:8000/;

        proxy_http_version 1.1;


        proxy_set_header Host \$host;

        proxy_set_header X-Real-IP \$remote_addr;

        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

        proxy_set_header X-Forwarded-Proto \$scheme;

    }


    location /health {

        return 200 "L-Panel Online";

        add_header Content-Type text/plain;

    }

}
EOF


nginx -t


systemctl restart nginx


echo
echo "=================================="
echo " Nginx configured successfully"
echo "=================================="

echo
echo "Frontend:"
echo "$FRONTEND_DIST"

echo
echo "Config:"
echo "$NGINX_CONF_FILE"
