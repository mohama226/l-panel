#!/bin/bash

detect_os() {

    if [ ! -f /etc/os-release ]; then
        error "Unsupported operating system."
    fi

    source /etc/os-release

    case "$ID" in

        ubuntu|debian)

            DISTRO="$ID"
            PKG="apt"

        ;;

        almalinux|rocky|centos)

            DISTRO="$ID"
            PKG="dnf"

        ;;

        *)

            error "Unsupported OS : $ID"

        ;;

    esac

    success "Operating System : $PRETTY_NAME"
    success "Package Manager  : $PKG"

}
