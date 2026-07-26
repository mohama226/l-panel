#!/bin/bash


create_database(){


echo "Database Configuration"

read -p "Database Name [lpanel]: " DB_NAME

DB_NAME=${DB_NAME:-lpanel}


read -p "Database User [lpanel]: " DB_USER

DB_USER=${DB_USER:-lpanel}


read -s -p "Database Password: " DB_PASS

echo ""


MYSQL_ROOT_PASSWORD=""



mysql -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"


mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"


mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"


mysql -e "FLUSH PRIVILEGES;"



ok "Database created"



}

