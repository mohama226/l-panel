#!/bin/bash

install_base_packages() {

info "Installing required packages..."

if [ "$PKG" = "apt" ]; then

    apt update

    apt install -y \
    git \
    curl \
    wget \
    unzip \
    zip \
    tar \
    ca-certificates \
    software-properties-common

else

    dnf makecache

    dnf install -y \
    git \
    curl \
    wget \
    unzip \
    zip \
    tar

fi

success "Base packages installed."

}
