#!/bin/bash


install_packages(){


if [ "$OS" = "almalinux" ]; then


dnf update -y

dnf install -y \
git \
curl \
wget \
unzip \
nginx \
mariadb-server \
php \
php-cli \
php-fpm \
php-mysqlnd \
php-mbstring \
php-xml \
php-bcmath \
php-json


else


apt update


apt install -y \
git \
curl \
wget \
unzip \
nginx \
mariadb-server \
php \
php-cli \
php-fpm \
php-mysql \
php-mbstring \
php-xml \
php-bcmath


fi


success "Packages installed"


}
