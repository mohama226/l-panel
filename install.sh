#!/bin/bash

set -e

echo "================================"
echo " l-panel Installer"
echo " Laravel ocserv panel"
echo "================================"


if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi


source /etc/os-release


echo "Detected OS: $ID"


case "$ID" in


almalinux|rocky|centos|rhel)

echo "RHEL based system"

bash <(curl -fsSL https://raw.githubusercontent.com/mohama226/l-panel/main/installer/rhel.sh)

;;


ubuntu|debian)

echo "Debian based system"

bash <(curl -fsSL https://raw.githubusercontent.com/mohama226/l-panel/main/installer/debian.sh)

;;


*)

echo "Unsupported OS $ID"

exit 1

;;

esac
