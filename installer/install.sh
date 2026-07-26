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


prepare_directory


install_project


install_composer


configure_database


create_admin


install_cli


success
