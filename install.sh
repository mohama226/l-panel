#!/bin/bash

set -e

echo "================================"
echo " Installing l-panel"
echo " ocserv management panel"
echo "================================"


if [ "$EUID" -ne 0 ]; then
    echo "Run installer as root"
    exit 1
fi


echo "[1/8] Detecting OS..."


source /etc/os-release


case "$ID" in


ubuntu|debian)

echo "Debian based system detected"

bash <(curl -fsSL https://raw.githubusercontent.com/mohama226/l-panel/main/installer/install_debian.sh)

;;


almalinux|rocky|centos|rhel)

echo "RHEL based system detected"

bash <(curl -fsSL https://raw.githubusercontent.com/mohama226/l-panel/main/installer/install_rhel.sh)

;;


*)

echo "Unsupported OS: $ID"

exit 1

;;

esac


echo ""
echo "================================"
echo " l-panel installed successfully"
echo "================================"

IP=$(hostname -I | awk '{print $1}')

echo ""
echo "Login URL:"
echo "http://$IP"
echo ""
