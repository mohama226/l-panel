#!/bin/bash

install_php(){

echo "[OK] Installing PHP 8.3"


dnf install -y epel-release

dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm


dnf module reset php -y

dnf module enable php:remi-8.3 -y


dnf install -y \
php \
php-cli \
php-fpm \
php-mysqlnd \
php-mbstring \
php-xml \
php-curl \
php-zip \
php-gd \
php-bcmath \
php-opcache


systemctl enable php-fpm
systemctl restart php-fpm


php -v

echo "[OK] PHP installed"

}
