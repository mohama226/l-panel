#!/bin/bash


install_composer(){

    if command -v composer >/dev/null 2>&1
    then
        success "Composer exists"
        composer --version
        return
    fi


    cd /tmp


    php -r "copy('https://getcomposer.org/installer','composer-setup.php');"


    php composer-setup.php --install-dir=/usr/local/bin --filename=composer


    rm -f composer-setup.php


    success "Composer installed"

}



install_dependencies(){

    cd /opt/l-panel


    if [ -f composer.json ]
    then

        composer install \
        --no-interaction \
        --prefer-dist \
        --optimize-autoloader


        success "Laravel dependencies installed"

    else

        error "composer.json not found"

        exit 1

    fi

}
