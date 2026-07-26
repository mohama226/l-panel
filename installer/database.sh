#!/bin/bash


install_database(){


systemctl enable mariadb
systemctl start mariadb


read -p "Database name [lpanel]: " DB_NAME

DB_NAME=${DB_NAME:-lpanel}



mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"


echo $DB_NAME > /tmp/lpanel_db


success "Database ready"


}
