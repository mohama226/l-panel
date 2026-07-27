#!/bin/bash

##################################################
# L-PANEL Installer v3 (Stable)
# Laravel OCServ VPN Management Panel
##################################################

set -e
clear

echo "
=================================
 L-PANEL INSTALLER v3 (Stable)
 OCServ VPN Management System
=================================
"

############################################
# ROOT CHECK
############################################

if [ "$EUID" -ne 0 ]; then
    echo "Please run installer as root"
    exit 1
fi

############################################
# L-PANEL INSTALL SETTINGS
############################################

echo "
L-PANEL Initial Setup
"

read -p "Enter Super Admin Username: " ADMIN_USERNAME

while true; do
    read -s -p "Enter Super Admin Password: " ADMIN_PASSWORD
    echo
    read -s -p "Confirm Password: " ADMIN_PASSWORD_CONFIRM
    echo

    if [ "$ADMIN_PASSWORD" == "$ADMIN_PASSWORD_CONFIRM" ]; then
        break
    else
        echo "Passwords do not match"
    fi
done

read -p "Enter Panel Port (default 80): " PANEL_PORT
[ -z "$PANEL_PORT" ] && PANEL_PORT=80

echo "
Admin Username: $ADMIN_USERNAME
Panel Port: $PANEL_PORT
"

############################################
# Detect OS
############################################

if [ ! -f /etc/os-release ]; then
    echo "Cannot detect operating system"
    exit 1
fi

source /etc/os-release
OS=$ID

echo "
Detected OS: $OS
"

############################################
# Update System
############################################

echo "
Updating system...
"

case "$OS" in
ubuntu|debian)
    apt update -y
;;
almalinux|rocky|rhel|centos)
    dnf update -y
;;
*)
    echo "Unsupported OS: $OS"
    exit 1
;;
esac

############################################
# Install AlmaLinux Packages
############################################

install_alma() {
echo "
Installing AlmaLinux dependencies...
"

dnf install -y epel-release dnf-utils || true
dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm || true

dnf module reset php -y || true
dnf module enable php:remi-8.2 -y || true

dnf install -y nginx mariadb-server php php-cli php-fpm php-mysqlnd php-mbstring php-xml php-json php-curl php-zip php-gd php-bcmath git curl wget unzip tar
}

############################################
# Install Ubuntu Packages
############################################

install_ubuntu() {
echo "
Installing Ubuntu dependencies...
"

apt install -y nginx mariadb-server php8.2 php8.2-cli php8.2-fpm php8.2-mysql php8.2-mbstring php8.2-xml php8.2-curl php8.2-zip php8.2-gd php8.2-bcmath git curl wget unzip
}

############################################
# Install Debian Packages
############################################

install_debian() {
echo "
Installing Debian dependencies...
"

apt install -y nginx mariadb-server php php-cli php-fpm php-mysql php-mbstring php-xml php-curl php-zip php-gd git curl wget unzip
}

############################################
# Run Installer
############################################

case "$OS" in
almalinux|rocky|rhel|centos)
    install_alma
;;
ubuntu)
    install_ubuntu
;;
debian)
    install_debian
;;
esac

echo "
Base packages installed successfully
"

############################################
# Install Composer
############################################

install_composer() {
echo "
Checking Composer...
"

if command -v composer >/dev/null 2>&1; then
    echo "Composer already installed"
else
    echo "Installing Composer..."
    cd /tmp
    php -r "copy('https://getcomposer.org/installer','composer-setup.php');"
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer
    rm -f composer-setup.php
fi

ln -s /usr/local/bin/composer /usr/bin/composer 2>/dev/null || true

composer --version
}

install_composer

############################################
# Clone L-PANEL
############################################

INSTALL_DIR="/var/www/l-panel"

echo "
Preparing L-PANEL directory...
"

if [ -f "$INSTALL_DIR/composer.json" ]; then
    echo "Existing L-PANEL installation found"
else
    echo "Downloading L-PANEL..."
    rm -rf $INSTALL_DIR
    mkdir -p /var/www
    git clone https://github.com/mohama226/l-panel.git $INSTALL_DIR
fi

cd $INSTALL_DIR

############################################
# Laravel Install
############################################

echo "
Configuring Composer...
"

composer config audit.block-insecure false

echo "
Installing Laravel dependencies...
"

composer install --no-interaction --prefer-dist --optimize-autoloader --no-audit

############################################
# Environment Setup
############################################

if [ ! -f .env ]; then
    echo "
Creating .env file...
"
    cp .env.example .env
fi

php artisan key:generate --force

############################################
# Database Configuration
############################################

DB_NAME="lpanel"
DB_USER="lpanel"
DB_PASS=$(openssl rand -base64 16)

echo "
Creating Database...
"

systemctl enable mariadb
systemctl start mariadb

mysql <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

############################################
# Update Laravel ENV
############################################

sed -i "s/DB_DATABASE=.*/DB_DATABASE=${DB_NAME}/" .env
sed -i "s/DB_USERNAME=.*/DB_USERNAME=${DB_USER}/" .env
sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=${DB_PASS}/" .env

echo "
Database configured
"

############################################
# Storage Link
############################################

php artisan storage:link || true

############################################
# Laravel Migration
############################################

echo "
Running database migration...
"

php artisan migrate --seed --force

############################################
# Create Super Admin
############################################

echo "
Creating Super Admin...
"

php artisan tinker --execute="
use App\Models\Admin;
Admin::create([
    'username' => '$ADMIN_USERNAME',
    'password' => password_hash('$ADMIN_PASSWORD', PASSWORD_BCRYPT),
    'role' => 'superadmin',
    'status' => 1
]);
"

############################################
# Optimize Laravel
############################################

php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

############################################
# Configure Nginx
############################################

echo "
Configuring Nginx...
"

cat > /etc/nginx/conf.d/l-panel.conf <<EOF
server {
    listen $PANEL_PORT;
    server_name _;
    root /var/www/l-panel/public;
    index index.php index.html;

    access_log /var/log/nginx/lpanel_access.log;
    error_log /var/log/nginx/lpanel_error.log;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/run/php-fpm/www.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\. {
        deny all;
    }
}
EOF

############################################
# PHP-FPM Configuration
############################################

if [ -f /etc/php-fpm.d/www.conf ]; then
    sed -i 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
    sed -i 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf
fi

############################################
# Permissions
############################################

echo "
Setting permissions...
"

chown -R nginx:nginx /var/www/l-panel/storage || true
chown -R nginx:nginx /var/www/l-panel/bootstrap/cache || true

chmod -R 775 /var/www/l-panel/storage
chmod -R 775 /var/www/l-panel/bootstrap/cache

############################################
# Enable Services
############################################

echo "
Starting services...
"

systemctl enable nginx
systemctl restart nginx

systemctl enable php-fpm || true
systemctl restart php-fpm || true

systemctl enable mariadb
systemctl restart mariadb

############################################
# Firewall
############################################

if command -v firewall-cmd >/dev/null 2>&1; then
    firewall-cmd --permanent --add-service=http || true
    firewall-cmd --permanent --add-service=https || true
    firewall-cmd --reload || true
fi

############################################
# Installation Finished
############################################

SERVER_IP=$(hostname -I | awk '{print $1}')

echo "
===========================================
 L-PANEL INSTALLATION COMPLETE

 URL:
 http://${SERVER_IP}:${PANEL_PORT}

 ADMIN LOGIN:
 Username: $ADMIN_USERNAME
 Password: $ADMIN_PASSWORD

 Project Path:
 /var/www/l-panel
===========================================
"
