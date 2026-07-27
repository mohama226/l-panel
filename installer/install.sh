#!/bin/bash


##################################################
# L-PANEL INSTALLER
# OCServ VPN Management Panel
##################################################


set -e



clear



echo "
=================================

 L-PANEL INSTALLER

 OCServ VPN Management System

=================================
"





############################################
# ROOT CHECK
############################################


if [ "$EUID" -ne 0 ]

then

echo "Run installer as root"

exit 1

fi





############################################
# OS DETECTION
############################################


if [ ! -f /etc/os-release ]

then

echo "OS detection failed"

exit 1

fi



source /etc/os-release



OS=$ID



echo "

Detected OS:

$OS

"






############################################
# USER INPUT
############################################



echo "

========== L-PANEL SETUP ==========

"



read -p "Super Admin Username: " ADMIN_USERNAME





while true

do


read -s -p "Super Admin Password: " ADMIN_PASSWORD

echo


read -s -p "Confirm Password: " ADMIN_PASSWORD_CONFIRM

echo



if [ "$ADMIN_PASSWORD" = "$ADMIN_PASSWORD_CONFIRM" ]

then

break

fi


echo "Password mismatch"



done






read -p "Panel Port [80]: " PANEL_PORT



if [ -z "$PANEL_PORT" ]

then

PANEL_PORT=80

fi





echo "

Admin:

$ADMIN_USERNAME


Port:

$PANEL_PORT

"






############################################
# SYSTEM UPDATE
############################################



case "$OS" in


ubuntu|debian)


apt update -y


;;



almalinux|rocky|rhel|centos)


dnf update -y


;;


*)


echo "Unsupported OS"

exit 1


;;


esac







############################################
# ALMA / ROCKY INSTALL
############################################



install_rhel(){


echo "

Installing RHEL packages...

"




dnf install -y epel-release || true



dnf install -y dnf-utils || true



dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm || true




dnf module reset php -y || true



dnf module enable php:remi-8.2 -y || true






dnf install -y nginx mariadb-server \
php php-cli php-fpm php-mysqlnd \
php-mbstring php-xml php-json \
php-curl php-zip php-gd php-bcmath \
git curl wget unzip tar openssl





}






############################################
# UBUNTU INSTALL
############################################


install_ubuntu(){


echo "

Installing Ubuntu packages...

"


apt install -y nginx mariadb-server \
php php-cli php-fpm \
php-mysql php-mbstring \
php-xml php-curl php-zip \
php-gd php-bcmath \
git curl wget unzip openssl



}







case "$OS" in


almalinux|rocky|rhel|centos)

install_rhel

;;



ubuntu|debian)

install_ubuntu

;;


esac





echo "

Base packages installed successfully

"
############################################
# INSTALL COMPOSER
############################################


install_composer(){


echo "

Checking Composer...

"



if command -v composer >/dev/null 2>&1

then


echo "Composer already installed"



else



echo "Installing Composer..."



cd /tmp



php -r "copy('https://getcomposer.org/installer','composer-setup.php');"



php composer-setup.php \
--install-dir=/usr/local/bin \
--filename=composer



rm -f composer-setup.php



fi



composer --version



}





install_composer







############################################
# DOWNLOAD L-PANEL
############################################



INSTALL_DIR="/var/www/l-panel"



echo "

Preparing L-PANEL directory...

"





if [ -f "$INSTALL_DIR/composer.json" ]

then


echo "Existing L-PANEL installation found"



else



echo "Downloading L-PANEL..."



rm -rf "$INSTALL_DIR"



mkdir -p /var/www



git clone https://github.com/mohama226/l-panel.git "$INSTALL_DIR"



fi







cd "$INSTALL_DIR"







############################################
# COMPOSER CONFIG
############################################



echo "

Configuring Composer...

"





composer config audit.block-insecure false






############################################
# INSTALL LARAVEL PACKAGES
############################################



echo "

Installing Laravel dependencies...

"





composer install \
--no-interaction \
--prefer-dist \
--optimize-autoloader \
--no-audit






############################################
# ENVIRONMENT FILE
############################################



if [ ! -f ".env" ]

then


cp .env.example .env



fi






php artisan key:generate --force







############################################
# DATABASE CREATE
############################################



echo "

Creating Database...

"





DB_NAME="lpanel"

DB_USER="lpanel"

DB_PASS=$(openssl rand -base64 18)







systemctl enable mariadb || true

systemctl start mariadb || true







mysql <<MYSQL_SCRIPT


CREATE DATABASE IF NOT EXISTS ${DB_NAME};


CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost'

IDENTIFIED BY '${DB_PASS}';



GRANT ALL PRIVILEGES ON ${DB_NAME}.*

TO '${DB_USER}'@'localhost';



FLUSH PRIVILEGES;



MYSQL_SCRIPT








############################################
# UPDATE ENV
############################################



sed -i "s/^DB_CONNECTION=.*/DB_CONNECTION=mysql/" .env


sed -i "s/^DB_HOST=.*/DB_HOST=127.0.0.1/" .env


sed -i "s/^DB_PORT=.*/DB_PORT=3306/" .env


sed -i "s/^DB_DATABASE=.*/DB_DATABASE=${DB_NAME}/" .env


sed -i "s/^DB_USERNAME=.*/DB_USERNAME=${DB_USER}/" .env


sed -i "s/^DB_PASSWORD=.*/DB_PASSWORD=${DB_PASS}/" .env





echo "

Database configured successfully

"







############################################
# PANEL SETTINGS
############################################



echo "PANEL_PORT=${PANEL_PORT}" >> .env





php artisan storage:link || true





echo "

Laravel setup completed

"
############################################
# DATABASE MIGRATION
############################################


echo "

Running Laravel migrations...

"



cd /var/www/l-panel



php artisan migrate --force






############################################
# CREATE SUPER ADMIN
############################################



echo "

Creating Super Admin...

"





php artisan tinker --execute="
use App\Models\Admin;
use Illuminate\Support\Facades\Hash;

Admin::updateOrCreate(
    ['username' => '$ADMIN_USERNAME'],
    [
        'name' => 'Super Admin',
        'username' => '$ADMIN_USERNAME',
        'password' => Hash::make('$ADMIN_PASSWORD'),
        'role' => 'super_admin'
    ]
);
"







############################################
# LARAVEL OPTIMIZE
############################################



php artisan optimize:clear


php artisan config:cache


php artisan route:cache


php artisan view:cache







############################################
# NGINX CONFIGURATION
############################################



echo "

Configuring Nginx...

"





cat > /etc/nginx/conf.d/l-panel.conf <<EOF


server {


listen ${PANEL_PORT};


server_name _;



root /var/www/l-panel/public;


index index.php index.html;




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
# PHP-FPM CONFIG
############################################



if [ -f /etc/php-fpm.d/www.conf ]

then



sed -i 's/^user = apache/user = nginx/' /etc/php-fpm.d/www.conf


sed -i 's/^group = apache/group = nginx/' /etc/php-fpm.d/www.conf



fi







############################################
# PERMISSIONS
############################################



echo "

Fixing permissions...

"





chown -R nginx:nginx /var/www/l-panel/storage || true


chown -R nginx:nginx /var/www/l-panel/bootstrap/cache || true



chmod -R 775 /var/www/l-panel/storage


chmod -R 775 /var/www/l-panel/bootstrap/cache







############################################
# FIREWALL
############################################



if command -v firewall-cmd >/dev/null 2>&1

then



firewall-cmd \
--permanent \
--add-port=${PANEL_PORT}/tcp || true



firewall-cmd --reload || true



fi







############################################
# ENABLE SERVICES
############################################



echo "

Starting services...

"





systemctl enable mariadb || true

systemctl restart mariadb || true





systemctl enable nginx || true

systemctl restart nginx





systemctl enable php-fpm || true

systemctl restart php-fpm || true








############################################
# INSTALL COMPLETE
############################################



SERVER_IP=$(hostname -I | awk '{print $1}')




echo "

===========================================

 L-PANEL INSTALL COMPLETE


 Panel URL:

 http://${SERVER_IP}:${PANEL_PORT}



 Super Admin:

 Username:

 ${ADMIN_USERNAME}



 Password:

 ${ADMIN_PASSWORD}



 Install Path:

 /var/www/l-panel



===========================================


"
