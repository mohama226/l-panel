#!/bin/bash


cd /opt/l-panel || exit 1


source installer/functions.sh
source installer/packages.sh
source installer/composer.sh
source installer/database.sh
source installer/env.sh
source installer/admin.sh


banner


detect_os


install_packages


install_composer


install_dependencies


create_database


create_env


run_migrations


create_admin


ok "L-Panel installation completed"
