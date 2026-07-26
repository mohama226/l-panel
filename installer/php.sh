#!/bin/bash

install_php() {

info "Installing PHP..."

if command -v php >/dev/null 2>&1; then

    success "PHP already installed."

    php -v | head -n1

    return

fi

if [ "$PKG" = "apt" ]; then

    apt install -y \
    php \
    php-cli \
    php-fpm \
    php-mysql \
    php-mbstring \
    php-xml \
    php-curl \
    php-gd \
    php-bcmath \
    php-zip

else

    dnf install -y epel-release

    dnf install -y \
    https://rpms.remirepo.net/enterprise/remi-release-9.rpm

    dnf module reset php -y

    dnf module enable php:remi-8.3 -y

    dnf install -y \
    php \
    php-cli \
    php-fpm \
    php-common \
    php-mysqlnd \
    php-mbstring \
    php-xml \
    php-curl \
    php-gd \
    php-bcmath \
    php-zip

fi

success "PHP Installed."

php -v | head -n1

}
