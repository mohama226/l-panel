#!/bin/bash

set -e


echo "Installing packages for Debian/Ubuntu"


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



echo "Packages installed"


systemctl enable nginx

systemctl start nginx


systemctl enable mariadb

systemctl start mariadb



echo "Downloading l-panel"


rm -rf /var/www/l-panel


git clone \
https://github.com/mohama226/l-panel.git \
/var/www/l-panel



cd /var/www/l-panel



echo "Installing Laravel"


composer install \
--no-interaction \
--prefer-dist \
--optimize-autoloader



if [ ! -f .env ]; then

cp .env.example .env

fi



php artisan key:generate



echo "Creating database"



mysql -e "
CREATE DATABASE IF NOT EXISTS lpanel
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
"



php artisan migrate --force



chown -R www-data:www-data /var/www/l-panel


systemctl restart nginx


echo "Debian installation completed"
