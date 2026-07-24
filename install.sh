#!/bin/bash

clear

echo "=============================="
echo " L-PANEL PHP INSTALLER"
echo "=============================="

read -p "Super Admin Username: " ADMIN_USER
read -s -p "Super Admin Password: " ADMIN_PASS
echo

read -p "Panel Port [8080]: " PORT

PORT=${PORT:-8080}


if [ -z "$ADMIN_USER" ] || [ -z "$ADMIN_PASS" ]; then
    echo "Username and password required"
    exit 1
fi


echo "Installing dependencies..."


if command -v dnf >/dev/null; then

dnf install -y \
httpd \
php \
php-mysqlnd \
mariadb-server \
git \
curl \
unzip

else

apt update

apt install -y \
apache2 \
php \
php-mysql \
mariadb-server \
git \
curl \
unzip

fi



echo "Removing old panel..."

rm -rf /var/www/html/l-panel



echo "Downloading L-PANEL"


git clone \
https://github.com/mohama226/l-panel.git \
/var/www/html/l-panel



if [ ! -f /var/www/html/l-panel/database/schema.sql ]; then

echo "Database schema missing"

exit 1

fi



echo "Checking structure..."

chown -R apache:apache /var/www/html/l-panel 2>/dev/null || true



echo "Creating database"



systemctl enable mariadb --now



mysql <<EOF

CREATE DATABASE IF NOT EXISTS lpanel
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;


CREATE USER IF NOT EXISTS 'lpanel'@'localhost'
IDENTIFIED BY 'lpanel123';


GRANT ALL PRIVILEGES
ON lpanel.*
TO 'lpanel'@'localhost';


FLUSH PRIVILEGES;

EOF



echo "Reset database"



mysql lpanel <<EOF

DROP TABLE IF EXISTS admin_logs;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS admins;

EOF



echo "Using schema:"

echo "/var/www/html/l-panel/database/schema.sql"



mysql lpanel < \
/var/www/html/l-panel/database/schema.sql



HASH=$(php -r "echo password_hash('$ADMIN_PASS', PASSWORD_DEFAULT);")



mysql lpanel <<EOF

INSERT INTO admins
(username,password,role)

VALUES

('$ADMIN_USER','$HASH','superadmin');

EOF




echo "Configuring Apache"



cat >/etc/httpd/conf.d/lpanel.conf <<EOF

Listen $PORT


<VirtualHost *:$PORT>


DocumentRoot /var/www/html/l-panel/public



<Directory /var/www/html/l-panel/public>

AllowOverride All

Require all granted

</Directory>



</VirtualHost>

EOF



systemctl restart httpd



chmod +x /var/www/html/l-panel/cli/l-panel

ln -sf /var/www/html/l-panel/cli/l-panel /usr/local/bin/l-panel



echo

echo "=============================="

echo " L-PANEL INSTALLED"

echo " Port : $PORT"

echo " User : $ADMIN_USER"

echo "=============================="
