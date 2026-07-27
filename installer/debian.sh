#!/bin/bash

set -e


PROJECT="/var/www/l-panel"



echo "Installing Debian dependencies"



apt update



apt install -y \
git \
curl \
unzip \
nginx \
mariadb-server \
php \
php-cli \
php-fpm \
php-mysql \
php-curl \
php-mbstring \
php-xml \
php-bcmath \
php-zip \
composer



systemctl enable nginx
systemctl start nginx


systemctl enable mariadb
systemctl start mariadb



rm -rf $PROJECT



git clone \
https://github.com/mohama226/l-panel.git \
$PROJECT



cd $PROJECT



composer install \
--no-interaction \
--prefer-dist \
--optimize-autoloader



cp .env.example .env



php artisan key:generate



mysql -e "
CREATE DATABASE IF NOT EXISTS lpanel;
"



sed -i 's/DB_DATABASE=.*/DB_DATABASE=lpanel/' .env



php artisan migrate --force



chown -R www-data:www-data $PROJECT



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
