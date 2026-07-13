#!/usr/bin/env bash


blue "Installing Nginx..."


apt install -y nginx


cat > /etc/nginx/sites-available/l-panel <<EOF

server {

listen 80;


server_name _;


location / {

proxy_pass http://127.0.0.1:${PANEL_PORT};


proxy_set_header Host \$host;

proxy_set_header X-Real-IP \$remote_addr;

}

}

EOF


ln -sf /etc/nginx/sites-available/l-panel /etc/nginx/sites-enabled/l-panel


nginx -t


systemctl restart nginx


green "Nginx Ready."
