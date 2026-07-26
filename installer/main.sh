#!/bin/bash

BASE_DIR="/tmp/lpanel-installer"


source $BASE_DIR/installer/functions.sh
source $BASE_DIR/installer/os.sh
source $BASE_DIR/installer/packages.sh
source $BASE_DIR/installer/php.sh
source $BASE_DIR/installer/composer.sh
source $BASE_DIR/installer/laravel.sh
source $BASE_DIR/installer/database.sh
source $BASE_DIR/installer/nginx.sh
source $BASE_DIR/installer/admin.sh
source $BASE_DIR/installer/command.sh


banner


detect_os


install_packages

install_php

install_composer


install_laravel


setup_database


create_admin


configure_nginx


install_command


echo ""
echo "================================="
echo " L-PANEL Laravel Installation OK "
echo "================================="
