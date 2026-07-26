#!/bin/bash

set -e


BASE_DIR="/opt/l-panel"


source installer/functions.sh
source installer/os.sh
source installer/composer.sh
source installer/database.sh
source installer/admin.sh
source installer/cli.sh


banner


detect_os


install_packages


install_composer


create_database


create_env


run_migrations


create_admin


install_cli


success
