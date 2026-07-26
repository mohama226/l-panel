#!/bin/bash

create_database(){

echo "Database Configuration"

read -p "Database Name [lpanel]: " DB_NAME

DB_NAME=${DB_NAME:-lpanel}


read -p "Database User [lpanel]: " DB_USER

DB_USER=${DB_USER:-lpanel}


read -s -p "Database Password (leave empty for auto): " DB_PASS

echo ""


if [ -z "$DB_PASS" ]; then

DB_PASS=$(openssl rand -base64 16)

fi


mysql <<MYSQL

CREATE DATABASE IF NOT EXISTS $DB_NAME
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;


CREATE USER IF NOT EXISTS '$DB_USER'@'localhost'
IDENTIFIED BY '$DB_PASS';


ALTER USER '$DB_USER'@'localhost'
IDENTIFIED BY '$DB_PASS';


GRANT ALL PRIVILEGES ON $DB_NAME.*
TO '$DB_USER'@'localhost';


FLUSH PRIVILEGES;

MYSQL


cat > /opt/l-panel/.env <<EOF

APP_NAME=L-Panel
APP_ENV=production
APP_DEBUG=false

APP_URL=http://127.0.0.1

DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=$DB_NAME
DB_USERNAME=$DB_USER
DB_PASSWORD=$DB_PASS

TIMEZONE=UTC

EOF


echo "[OK] Database created"

echo "[OK] .env created"


}
