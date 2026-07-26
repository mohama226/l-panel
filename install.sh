#!/bin/bash

set -e

echo "================================"
echo " Installing l-panel"
echo " ocserv management panel"
echo "================================"


PROJECT="l-panel"
INSTALL_DIR="/var/www/l-panel"


echo "[1/8] Detecting OS..."

OS=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')


case $OS in

ubuntu|debian)
    echo "Supported OS: $OS"
    ;;

*)
    echo "Unsupported OS: $OS"
    exit 1
    ;;

esac


echo "[2/8] Installing packages..."

apt update

apt install -y \
git \
curl \
unzip \
nginx \
mysql-server \
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


echo "[3/8] Download l-panel..."

if [ -d "$INSTALL_DIR" ]; then
    rm -rf $INSTALL_DIR
fi


git clone \
https://github.com/mohama226/l-panel.git \
$INSTALL_DIR


cd $INSTALL_DIR


echo "[4/8] Installing Laravel..."

composer install \
--no-interaction \
--prefer-dist \
--optimize-autoloader


echo "[5/8] Configuring environment..."

cp .env.example .env


php artisan key:generate


echo "[6/8] Database setup..."

mysql -e "CREATE DATABASE lpanel CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"


php artisan migrate --force


echo "[7/8] Creating admin user..."

php artisan db:seed --class=AdminSeeder


echo "[8/8] Starting services..."


chown -R www-data:www-data $INSTALL_DIR


systemctl restart nginx
systemctl restart php*-fpm


IP=$(hostname -I | awk '{print $1}')


echo ""
echo "================================"
echo " l-panel installed successfully"
echo ""
echo " Login URL:"
echo ""
echo " http://$IP"
echo ""
echo " Default Admin:"
echo " admin@l-panel.local"
echo " password: change-me"
echo "================================"
