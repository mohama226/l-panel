#!/bin/bash

configure_nginx(){

echo ""
read -p "Panel Port [2096]: " PANEL_PORT

PANEL_PORT=${PANEL_PORT:-2096}


cat > /etc/nginx/conf.d/l-panel.conf <<EOF

server {

    listen ${PANEL_PORT};

    server_name _;

    root /opt/l-panel/public;

    index index.php index.html;


    location / {

        try_files \$uri \$uri/ /index.php?\$query_string;

    }


    location ~ \.php$ {

        include fastcgi_params;

        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;

        fastcgi_pass unix:/run/php-fpm/www.sock;

    }


    location ~ /\. {

        deny all;

    }

}

EOF


nginx -t

systemctl restart nginx


echo "[OK] Nginx configured on port ${PANEL_PORT}"

echo "${PANEL_PORT}" > /opt/l-panel/.panel-port

}
