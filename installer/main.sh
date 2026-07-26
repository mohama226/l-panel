#!/bin/bash


BASE_DIR="/tmp/lpanel-installer"


source $BASE_DIR/installer/functions.sh
source $BASE_DIR/installer/os.sh
source $BASE_DIR/installer/packages.sh
source $BASE_DIR/installer/composer.sh
source $BASE_DIR/installer/laravel.sh
source $BASE_DIR/installer/database.sh
source $BASE_DIR/installer/admin.sh
source $BASE_DIR/installer/nginx.sh
source $BASE_DIR/installer/command.sh


banner


detect_os


install_packages


install_composer


install_laravel


install_dependencies


create_database


create_admin


configure_nginx


create_command


success "L-Panel installed successfully"
