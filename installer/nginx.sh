#!/bin/bash


install_nginx(){

echo "[OK] Configuring Nginx"


cat > /etc/nginx/conf.d/l-panel.conf <<EOF

server {

    listen 2096;

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


systemctl enable nginx

systemctl restart nginx


echo "[OK] Nginx configured"

}
