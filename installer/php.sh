#!/bin/bash


install_php(){

echo "[OK] Installing PHP 8.3"


if [ "$OS" = "almalinux" ]; then


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
php-bcmath \
php-curl \
php-zip \
php-gd \
php-intl \
php-opcache


systemctl enable php-fpm

systemctl restart php-fpm


else


apt update

apt install -y \
php8.3 \
php8.3-cli \
php8.3-fpm \
php8.3-mysql \
php8.3-mbstring \
php8.3-xml \
php8.3-bcmath \
php8.3-curl \
php8.3-zip


systemctl enable php8.3-fpm

systemctl restart php8.3-fpm


fi


php -v

}
