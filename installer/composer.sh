#!/bin/bash

install_composer() {

info "Installing Composer..."

if command -v composer >/dev/null 2>&1; then

    success "Composer already installed."

    composer --version

    return

fi

php -r "copy('https://getcomposer.org/installer','composer-setup.php');"

php composer-setup.php --install-dir=/usr/local/bin --filename=composer

rm -f composer-setup.php

success "Composer Installed."

composer --version

}
