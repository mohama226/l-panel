#!/bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"


ok(){

echo -e "${GREEN}[OK]${NC} $1"

}


error(){

echo -e "${RED}[ERROR]${NC} $1"
exit 1

}


banner(){

clear

echo "================================="
echo "       L-PANEL INSTALLER"
echo "              v2.0"
echo "================================="

}


detect_os(){

if [ -f /etc/almalinux-release ]; then

OS="almalinux"

elif [ -f /etc/ubuntu-release ] || [ -f /etc/debian_version ]; then

OS="ubuntu"

else

error "Unsupported OS"

fi


ok "Operating System detected: $OS"

}
