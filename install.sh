#!/bin/bash

set -e

echo "======================================"
echo "        l-panel Installer"
echo "   ocserv VPN Management Panel"
echo "======================================"

INSTALL_DIR="/var/www/l-panel"


if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi


echo "[1/6] Detecting operating system..."


if [ ! -f /etc/os-release ]; then
    echo "Cannot detect operating system"
    exit 1
fi


source /etc/os-release


OS=$ID


echo "Detected OS: $OS"



case $OS in

ubuntu|debian)

    echo "Debian based system detected"

    bash <(curl -s https://raw.githubusercontent.com/mohama226/l-panel/main/installer/install_debian.sh)

    ;;


almalinux|rocky|centos|rhel)

    echo "RHEL based system detected"

    bash <(curl -s https://raw.githubusercontent.com/mohama226/l-panel/main/installer/install_rhel.sh)

    ;;


*)

    echo ""
    echo "Unsupported OS: $OS"
    echo "Supported:"
    echo "Ubuntu"
    echo "Debian"
    echo "AlmaLinux"
    echo "Rocky Linux"
    echo "CentOS"
    exit 1

;;

esac



echo ""
echo "======================================"
echo " l-panel installation finished"
echo "======================================"

IP=$(hostname -I | awk '{print $1}')


echo ""
echo "Open browser:"
echo ""
echo "http://$IP"
echo ""
