#!/bin/bash

TARGET_DIR="/var/www/lpanel"

rm -rf $TARGET_DIR
mkdir -p $TARGET_DIR

cp -r ./ $TARGET_DIR

chown -R apache:apache $TARGET_DIR
chmod -R 755 $TARGET_DIR

cat >/etc/httpd/conf.d/lpanel.conf <<EOF
Listen 2096

<VirtualHost *:2096>
    DocumentRoot /var/www/lpanel/public

    <Directory /var/www/lpanel/public>
        AllowOverride All
        Require all granted
    </Directory>

    <FilesMatch \.php$>
        SetHandler "proxy:unix:/var/run/php-fpm/www.sock|fcgi://localhost"
    </FilesMatch>
</VirtualHost>
EOF

systemctl restart php-fpm
systemctl restart httpd

mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS lpanel;
CREATE USER IF NOT EXISTS 'lpanel_user'@'localhost' IDENTIFIED BY 'lpanel_pass';
GRANT ALL PRIVILEGES ON lpanel.* TO 'lpanel_user'@'localhost';
FLUSH PRIVILEGES;
EOF

mysql -u lpanel_user -plpanel_pass lpanel < /var/www/lpanel/sql/schema.sql
