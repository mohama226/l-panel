#!/bin/bash


#############################################
# L-PANEL Installer
# Laravel OCServ VPN Management Panel
#############################################



set -e





echo "
=================================

 L-PANEL INSTALLER

 OCServ VPN Management System

=================================
"





#############################################
# Root Check
#############################################


if [ "$EUID" -ne 0 ]

then

echo "Please run installer as root"

exit 1

fi







#############################################
# Detect OS
#############################################



if [ -f /etc/os-release ]

then

    . /etc/os-release


else

    echo "Unknown Linux"

    exit 1

fi






OS=$ID



echo "

Detected OS:

$OS

"








#############################################
# Install Packages
#############################################



install_ubuntu(){


echo "Installing Ubuntu packages..."



apt update



apt install -y \

nginx \

mariadb-server \

php \

php-cli \

php-fpm \

php-mysql \

php-curl \

php-mbstring \

php-xml \

php-zip \

php-bcmath \

php-gd \

unzip \

git \

curl \

composer \

nodejs \

npm




}








install_debian(){


echo "Installing Debian packages..."



apt update



apt install -y \

nginx \

mariadb-server \

php \

php-cli \

php-fpm \

php-mysql \

php-curl \

php-mbstring \

php-xml \

php-zip \

php-bcmath \

unzip \

git \

curl \

composer




}








install_alma(){


echo "Installing AlmaLinux packages..."



dnf update -y



dnf install -y \

nginx \

mariadb-server \

php \

php-cli \

php-fpm \

php-mysqlnd \

php-curl \

php-mbstring \

php-xml \

php-zip \

unzip \

git \

curl





}



#############################################
# OS Switch
#############################################


case $OS in


ubuntu)

install_ubuntu

;;


debian)

install_debian

;;



almalinux|rhel|centos)

install_alma

;;



*)

echo "Unsupported OS"

exit 1

;;



esac






#############################################
# Composer Check
#############################################


if ! command -v composer &> /dev/null

then



echo "Installing Composer..."



php -r "copy('https://getcomposer.org/installer','composer-setup.php');"



php composer-setup.php



mv composer.phar /usr/local/bin/composer



rm composer-setup.php



fi








#############################################
# Laravel Setup
#############################################



PROJECT_DIR=$(pwd)



echo "

Installing Laravel dependencies...

"



composer install --no-dev --optimize-autoloader





#############################################
# Environment
#############################################



if [ ! -f .env ]

then



cp .env.example .env



fi





php artisan key:generate





#############################################
# Database Setup
#############################################



echo "

Running migrations...

"



php artisan migrate --seed --force







#############################################
# Permissions
#############################################



chmod -R 775 storage

chmod -R 775 bootstrap/cache







#############################################
# Services
#############################################



systemctl enable nginx

systemctl restart nginx





systemctl enable mariadb

systemctl restart mariadb






#############################################
# Finish
#############################################



echo "

=================================

 L-PANEL INSTALLED SUCCESSFULLY


 Login:

 URL:

 http://YOUR_SERVER_IP/admin/login


 Username:

 admin


 Password:

 admin123


=================================

"
