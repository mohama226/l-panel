#!/bin/bash


install_packages(){

echo "Installing required packages..."


if [ "$OS" = "almalinux" ]; then

dnf install -y \
git \
curl \
wget \
unzip \
zip \
nginx \
mariadb-server \
php \
php-cli \
php-fpm \
php-mysqlnd \
php-mbstring \
php-xml \
php-gd \
php-bcmath \
php-intl \
php-opcache

fi


if [ "$OS" = "ubuntu" ]; then

apt update

apt install -y \
git \
curl \
wget \
unzip \
zip \
nginx \
mariadb-server \
php \
php-cli \
php-fpm \
php-mysql \
php-mbstring \
php-xml \
php-gd \
php-bcmath \
php-intl

fi


ok "Packages installed"

}
