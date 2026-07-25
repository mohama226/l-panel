#!/bin/bash

echo "🔧 Installing L-Panel..."

TARGET_DIR="/var/www/lpanel"

rm -rf $TARGET_DIR
mkdir -p $TARGET_DIR

echo "📥 Copying project..."
cp -r ./ $TARGET_DIR

echo "📁 Setting permissions..."
chown -R apache:apache $TARGET_DIR
chmod -R 755 $TARGET_DIR

echo "⚙️ Creating Apache config..."

cat >/etc/httpd/conf.d/lpanel.conf <<EOF
Listen 2096

<VirtualHost *:2096>
    ServerName lpanel.local
    DocumentRoot /var/www/lpanel/public

    <Directory /var/www/lpanel/public>
        AllowOverride All
        Require all granted
    </Directory>

    <FilesMatch \.php$>
        SetHandler "proxy:unix:/var/run/php-fpm/www.sock|fcgi://localhost"
    </FilesMatch>

    ErrorLog /var/log/httpd/lpanel_error.log
    CustomLog /var/log/httpd/lpanel_access.log combined
</VirtualHost>
EOF

echo "🔄 Restarting Apache & PHP-FPM..."
systemctl restart php-fpm
systemctl restart httpd

echo "🗄️ Creating database..."

mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS lpanel;
CREATE USER IF NOT EXISTS 'lpanel_user'@'localhost' IDENTIFIED BY 'lpanel_pass';
GRANT ALL PRIVILEGES ON lpanel.* TO 'lpanel_user'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "📦 Importing schema..."
mysql -u lpanel_user -plpanel_pass lpanel < /var/www/lpanel/sql/schema.sql

echo "✅ Installation completed!"
echo "Panel is now available at: http://YOUR-IP:2096"
