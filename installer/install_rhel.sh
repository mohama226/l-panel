#!/bin/bash

set -e


echo "Installing packages for AlmaLinux/RHEL"


dnf update -y



dnf install -y \
epel-release



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



echo "Installing Composer"


cd /tmp


php -r "copy('https://getcomposer.org/installer','composer-setup.php');"


php composer-setup.php \
--install-dir=/usr/local/bin \
--filename=composer



systemctl enable nginx

systemctl start nginx



systemctl enable mariadb

systemctl start mariadb



systemctl enable php-fpm

systemctl start php-fpm



echo "Downloading l-panel"


rm -rf /var/www/l-panel


git clone \
https://github.com/mohama226/l-panel.git \
/var/www/l-panel



cd /var/www/l-panel



composer install \
--no-interaction \
--prefer-dist \
--optimize-autoloader



cp .env.example .env



php artisan key:generate



mysql -e "
CREATE DATABASE IF NOT EXISTS lpanel
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
"



php artisan migrate --force



chown -R nginx:nginx /var/www/l-panel



systemctl restart nginx



echo "RHEL installation completed"
