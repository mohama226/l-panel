#!/usr/bin/env bash

source "$(dirname "$0")/variables.sh"

source "$(dirname "$0")/functions.sh"


blue "Installing Nginx..."


apt install -y nginx


cat > /etc/nginx/sites-available/l-panel <<EOF

server {

    listen 80;

    server_name _;


    location / {

        proxy_pass http://127.0.0.1:${PANEL_PORT};

        proxy_http_version 1.1;

        proxy_set_header Host \$host;

        proxy_set_header X-Real-IP \$remote_addr;

        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

    }

}

EOF


rm -f /etc/nginx/sites-enabled/default


ln -sf /etc/nginx/sites-available/l-panel \
/etc/nginx/sites-enabled/l-panel


nginx -t


systemctl restart nginx


green "Nginx configured."
