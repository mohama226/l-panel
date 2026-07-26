#!/bin/bash

set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$BASE_DIR/functions.sh"
source "$BASE_DIR/os.sh"
source "$BASE_DIR/packages.sh"
source "$BASE_DIR/php.sh"
source "$BASE_DIR/mariadb.sh"
source "$BASE_DIR/nginx.sh"
source "$BASE_DIR/composer.sh"
source "$BASE_DIR/project.sh"
source "$BASE_DIR/service.sh"
source "$BASE_DIR/cli.sh"
banner

detect_os

install_base_packages

install_php

install_mariadb

install_nginx

install_composer

install_project

configure_services

install_cli

finish_install
