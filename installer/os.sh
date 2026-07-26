#!/bin/bash


detect_os(){

if [ -f /etc/almalinux-release ]; then

OS="almalinux"

elif [ -f /etc/ubuntu-release ] || grep -q Ubuntu /etc/os-release; then

OS="ubuntu"

else

error "Unsupported OS"

fi


success "Detected OS: $OS"

}
