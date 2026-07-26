#!/bin/bash

install_composer(){

    echo "Installing Composer..."

    if command -v composer >/dev/null 2>&1
    then
        ok "Composer already installed"
        composer --version
        return
    fi

    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

    php composer-setup.php \
        --install-dir=/usr/local/bin \
        --filename=composer

    rm -f composer-setup.php

    ok "Composer installed"

    composer --version
}

install_project_dependencies(){

    echo "Installing L-Panel dependencies..."

    cd /opt/l-panel

    if [ ! -f composer.json ]; then
        error "composer.json not found"
    fi

    composer install \
        --no-interaction \
        --prefer-dist \
        --optimize-autoloader

    ok "Composer dependencies installed"
}
