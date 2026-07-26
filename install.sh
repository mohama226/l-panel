#!/bin/bash

set -e

BASE_DIR="/tmp/lpanel-installer"

rm -rf $BASE_DIR
mkdir -p $BASE_DIR

cd $BASE_DIR


git clone https://github.com/mohama226/l-panel.git .


source installer/functions.sh
source installer/os.sh
source installer/packages.sh
source installer/composer.sh
source installer/database.sh
source installer/nginx.sh
source installer/laravel.sh
source installer/admin.sh
source installer/command.sh


banner


detect_os

install_packages

install_composer

install_database

install_laravel

create_admin

configure_nginx

install_command


success "L-Panel installation completed"

echo ""
echo "Run:"
echo ""
echo "l-panel"
echo ""
