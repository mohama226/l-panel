#!/bin/bash

set -e


PROJECT="/var/www/l-panel"


echo "Installing RHEL dependencies"


dnf install -y epel-release


dnf install -y \
git \
curl \
unzip \
nginx \
mariadb-server \
php \
php-cli \
php-fpm \
php-mysqlnd \
php-curl \
php-mbstring \
php-xml \
php-bcmath \
php-zip



systemctl enable nginx
systemctl start nginx


systemctl enable mariadb
systemctl start mariadb


systemctl enable php-fpm
systemctl start php-fpm



echo "Installing Composer"


cd /tmp


php -r "copy('https://getcomposer.org/installer','composer-setup.php');"


php composer-setup.php \
--install-dir=/usr/local/bin \
--filename=composer



echo "Downloading l-panel"



rm -rf $PROJECT



git clone \
https://github.com/mohama226/l-panel.git \
$PROJECT



cd $PROJECT



echo "Installing Laravel"



composer install \
--no-interaction \
--prefer-dist \
--optimize-autoloader



cp .env.example .env



php artisan key:generate



echo "Creating database"



mysql -e "
CREATE DATABASE IF NOT EXISTS lpanel
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
"



sed -i 's/DB_DATABASE=.*/DB_DATABASE=lpanel/' .env



php artisan migrate --force



chown -R nginx:nginx $PROJECT



systemctl restart nginx



IP=$(hostname -I | awk '{print $1}')



echo ""
echo "================================"
echo " l-panel installed successfully"
echo "================================"
echo ""
echo "Open:"
echo "http://$IP"
echo ""
