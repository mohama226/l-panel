#!/bin/bash


#################################################
# L-PANEL Installer
# OCServ VPN Management Panel
#################################################


set -e



echo "
===================================
       L-PANEL INSTALLER
===================================
"



if [ "$EUID" -ne 0 ]
then

echo "Please run as root"

exit 1

fi



#################################################
# Detect OS
#################################################


echo "[+] Detecting operating system..."



if [ -f /etc/os-release ]
then

source /etc/os-release

else

echo "Unknown Linux"

exit 1

fi




OS=$ID



echo "[+] OS detected: $OS"





#################################################
# Install Packages
#################################################


install_ubuntu()
{


echo "[+] Installing Ubuntu packages"



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

php-mbstring \

php-xml \

php-curl \

php-zip \

composer





}




install_alma()
{


echo "[+] Installing AlmaLinux packages"



dnf update -y



dnf install -y \

epel-release



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

php-curl \

composer



}




case $OS in


ubuntu|debian)


install_ubuntu

;;



almalinux|rocky|centos)


install_alma

;;



*)


echo "Unsupported OS"

exit 1


;;


esac





#################################################
# Enable Services
#################################################


echo "[+] Starting services"



systemctl enable nginx

systemctl start nginx



systemctl enable redis

systemctl start redis



systemctl enable postgresql

systemctl start postgresql






#################################################
# Clone Project
#################################################


INSTALL_DIR="/var/www/l-panel"



if [ -d "$INSTALL_DIR" ]

then


echo "[+] Existing installation found"



else



echo "[+] Downloading L-PANEL"



mkdir -p /var/www



git clone \

https://github.com/YOUR_USERNAME/l-panel.git \

$INSTALL_DIR



fi






#################################################
# Laravel Setup
#################################################



cd $INSTALL_DIR



echo "[+] Installing Composer packages"



composer install --no-dev --optimize-autoloader





if [ ! -f ".env" ]

then


cp .env.example .env


fi




php artisan key:generate





#################################################
# Database Setup
#################################################


echo "[+] Creating database"



sudo -u postgres psql <<EOF


CREATE DATABASE lpanel;


CREATE USER lpanel WITH PASSWORD 'lpanel_password';


GRANT ALL PRIVILEGES ON DATABASE lpanel TO lpanel;


EOF






#################################################
# Environment
#################################################


sed -i \

"s/DB_DATABASE=.*/DB_DATABASE=lpanel/" \

.env



sed -i \

"s/DB_USERNAME=.*/DB_USERNAME=lpanel/" \

.env



sed -i \

"s/DB_PASSWORD=.*/DB_PASSWORD=lpanel_password/" \

.env






#################################################
# Laravel Migration
#################################################


echo "[+] Running migrations"



php artisan migrate --force





#################################################
# Storage Permission
#################################################


echo "[+] Setting permissions"



chown -R www-data:www-data $INSTALL_DIR



chmod -R 775 storage

chmod -R 775 bootstrap/cache






#################################################
# Nginx Config
#################################################


cat > /etc/nginx/conf.d/l-panel.conf <<EOF


server {


listen 80;


server_name _;



root $INSTALL_DIR/public;



index index.php index.html;



location / {


try_files \$uri \$uri/ /index.php?\$query_string;


}



location ~ \.php$ {


include fastcgi_params;


fastcgi_pass unix:/run/php/php-fpm.sock;


fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;


}



}


EOF






nginx -t


systemctl restart nginx






#################################################
# Create Admin
#################################################


echo "

===================================
Installation Finished
===================================

Admin Panel:

http://SERVER-IP/admin/login


Default admin:

username:
admin


password:
admin123


Please change password immediately.

"



