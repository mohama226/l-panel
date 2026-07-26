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
