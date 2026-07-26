#!/bin/bash

install_mariadb() {

info "Installing MariaDB..."

if command -v mysql >/dev/null 2>&1; then

    success "MariaDB already installed."

    return

fi

if [ "$PKG" = "apt" ]; then

    apt install -y mariadb-server

else

    dnf install -y mariadb-server

fi

systemctl enable mariadb
systemctl restart mariadb

success "MariaDB Installed."

}
