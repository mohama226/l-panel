#!/bin/bash

set -e

BASE="/opt/lak-panel"

clear

echo "========================================="
echo "          LAK PANEL INSTALLER"
echo "              VERSION 1.0"
echo "========================================="

echo
echo "Install Path:"
echo "$BASE"
echo

if [ "$EUID" -ne 0 ]; then
    echo "Run as root"
    exit 1
fi


mkdir -p $BASE


echo "Updating system..."

apt update -y


apt install -y \
python3 \
python3-pip \
python3-venv \
curl \
wget \
unzip \
sqlite3 \
systemd


echo
echo "========================================="
echo " Create Super Admin"
echo "========================================="

read -p "Username: " ADMIN_USER

while true
do
read -s -p "Password: " ADMIN_PASS
echo

read -s -p "Confirm Password: " ADMIN_PASS2
echo

if [ "$ADMIN_PASS" = "$ADMIN_PASS2" ]; then
break
fi

echo "Passwords not match"
done


echo
echo "========================================="
read -p "Panel Port [2096]: " PANEL_PORT

PANEL_PORT=${PANEL_PORT:-2096}


echo
echo "Install OCServ?"
echo "1) Yes"
echo "2) No"

read OC


echo
echo "Enable Backup System?"
echo "1) Yes"
echo "2) No"

read BACKUP


echo
echo "Install Kolomb Script?"
echo "1) Yes"
echo "2) No"

read KOLOMB



mkdir -p $BASE/config


cat > $BASE/config/install.conf <<EOF
ADMIN_USER=$ADMIN_USER
ADMIN_PASS=$ADMIN_PASS
PORT=$PANEL_PORT
OCSERV=$OC
BACKUP=$BACKUP
KOLOMB=$KOLOMB
EOF



chmod +x $BASE/installer/*.sh


bash $BASE/installer/install_panel.sh



if [ "$OC" = "1" ]; then
bash $BASE/installer/install_ocserv.sh
fi


if [ "$BACKUP" = "1" ]; then
bash $BASE/installer/install_backup.sh
fi


if [ "$KOLOMB" = "1" ]; then
bash $BASE/installer/install_kolomb.sh
fi



echo
echo "========================================="
echo " LAK PANEL INSTALLED"
echo "========================================="

echo
echo "Panel:"
echo "http://SERVER-IP:$PANEL_PORT"

echo
echo "Command:"
echo "lak-panel"

echo
