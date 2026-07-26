#!/bin/bash

detect_os(){

    if [ -f /etc/almalinux-release ]; then

        OS="almalinux"
        PKG="dnf"

    elif [ -f /etc/ubuntu-release ] || [ -f /etc/debian_version ]; then

        OS="ubuntu"
        PKG="apt"

    else
        error "Unsupported OS"
    fi

    ok "Operating System detected: $OS"
}

install_packages(){

    if [ "$OS" = "almalinux" ]; then

        dnf update -y

        dnf install -y \
            git \
            curl \
            wget \
            unzip \
            nginx \
            mariadb-server \
            php \
            php-fpm \
            php-mysqlnd

    else

        apt update -y

        apt install -y \
            git \
            curl \
            wget \
            unzip \
            nginx \
            mariadb-server \
            php \
            php-fpm \
            php-mysql

    fi

    ok "Packages installed"
}
