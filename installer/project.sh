#!/bin/bash

PROJECT_DIR="/opt/l-panel"

install_project() {

info "Installing L-Panel..."

if [ -d "$PROJECT_DIR/.git" ]; then

    success "Existing installation found."

    cd "$PROJECT_DIR"

    git fetch origin

    git reset --hard origin/main

else

    rm -rf "$PROJECT_DIR"

    git clone https://github.com/mohama226/l-panel.git "$PROJECT_DIR"

    cd "$PROJECT_DIR"

fi

if [ -f composer.json ]; then

    composer install --no-dev --optimize-autoloader

fi

mkdir -p storage

chmod -R 775 storage

success "Project Installed."

}
