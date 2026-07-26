#!/bin/bash

install_nginx() {

info "Installing Nginx..."

if command -v nginx >/dev/null 2>&1; then

    success "Nginx already installed."

else

    if [ "$PKG" = "apt" ]; then

        apt install -y nginx

    else

        dnf install -y nginx

    fi

fi

systemctl enable nginx
systemctl restart nginx

success "Nginx Installed."

}
