#!/bin/bash


#################################################
# L-PANEL AUTO INSTALLER
# OCServ VPN Management Panel
#################################################


set -e



echo "
=================================
        L-PANEL INSTALLER
=================================
"



if [ "$EUID" -ne 0 ]
then

echo "Please run as root"

exit 1

fi



#################################################
# Detect OS
#################################################


detect_os()
{


if [ -f /etc/os-release ]
then

. /etc/os-release


case $ID in


ubuntu|debian)

OS="debian"

;;


almalinux|rocky|centos|rhel)

OS="rhel"

;;


*)

echo "Unsupported OS"

exit 1

;;

esac


else

echo "Cannot detect OS"

exit 1


fi



}



detect_os



echo "Detected OS: $OS"




#################################################
# Install Packages Debian
#################################################


install_debian()
{


apt update



apt install -y \

curl \

git \

unzip \

nginx \

postgresql \

postgresql-contrib \

redis-server \

php \

php-cli \

php-fpm \

php-pgsql \

php-curl \

php-mbstring \

php-xml \

php-zip \

php-bcmath



}



#################################################
# Install Packages RHEL
#################################################


install_rhel()
{


dnf update -y



dnf install -y \

curl \

git \

unzip \

nginx \

postgresql-server \

redis \

php \

php-cli \

php-fpm \

php-pgsql \

php-mbstring \

php-xml \

php-json \

php-zip



}



#################################################
# Execute Installer
#################################################


if [ "$OS" = "debian" ]

then


install_debian


else


install_rhel


fi





#################################################
# Composer Install
#################################################


if ! command -v composer &> /dev/null

then


php -r "copy('https://getcomposer.org/installer','composer-setup.php');"


php composer-setup.php


mv composer.phar /usr/local/bin/composer


fi





echo "Composer installed"





#################################################
# Clone Project
#################################################


INSTALL_DIR="/var/www/l-panel"



if [ ! -d "$INSTALL_DIR" ]

then


git clone \

https://github.com/YOUR_USERNAME/l-panel.git \

$INSTALL_DIR



fi





cd $INSTALL_DIR





#################################################
# Laravel Setup
#################################################


composer install --no-interaction



if [ ! -f ".env" ]

then


cp .env.example .env


fi



php artisan key:generate





#################################################
# Database
#################################################


echo "Creating database"



sudo -u postgres psql <<EOF

CREATE DATABASE lpanel;

CREATE USER lpanel WITH PASSWORD 'change_password';

GRANT ALL PRIVILEGES ON DATABASE lpanel TO lpanel;

EOF





#################################################
# Migration
#################################################


php artisan migrate --force






#################################################
# Storage Permission
#################################################


chown -R www-data:www-data $INSTALL_DIR/storage

chown -R www-data:www-data $INSTALL_DIR/bootstrap/cache





#################################################
# Services Start
#################################################


systemctl enable nginx

systemctl enable redis



systemctl restart nginx

systemctl restart redis






#################################################
# Finish
#################################################


echo "

======================================

L-PANEL Installed Successfully


Path:

$INSTALL_DIR


Next:

Edit .env

Create admin:

php artisan db:seed


======================================

"
