#!/bin/bash

set -e

clear

echo "================================="
echo "       LAK PANEL INSTALLER"
echo "================================="

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi


echo ""
echo "Enter SuperAdmin username:"
read SUPERADMIN


echo ""
echo "Enter SuperAdmin password:"
read -s ADMIN_PASS
echo ""


echo ""
echo "Enter panel port:"
read PANEL_PORT


if [ -z "$PANEL_PORT" ]; then
    PANEL_PORT=2096
fi


echo ""
echo "Install ocserv 1.5 ?"
echo "1) Yes"
echo "2) No"

read OC_INSTALL


echo ""
echo "================================="
echo "Configuration"
echo "================================="

echo "Admin:"
echo "$SUPERADMIN"

echo "Port:"
echo "$PANEL_PORT"

echo "Install OCServ:"
echo "$OC_INSTALL"

echo ""
read -p "Continue? (y/n): " CONFIRM


if [[ "$CONFIRM" != "y" ]]; then
    echo "Installation cancelled"
    exit 0
fi



echo ""
echo "[1/7] Updating system..."

apt update -y
apt upgrade -y



echo ""
echo "[2/7] Installing requirements..."

apt install -y \
python3 \
python3-pip \
python3-venv \
postgresql \
postgresql-contrib \
nginx \
unzip \
curl \
git



echo ""
echo "[3/7] Creating directories..."


mkdir -p /opt/lak-panel


echo ""
echo "[4/7] Installing panel files..."



echo ""
echo "Waiting for release package..."



echo ""
echo "[5/7] PostgreSQL setup..."



DB_NAME="lakpanel"
DB_USER="lakpanel"


DB_PASS=$(openssl rand -hex 16)



sudo -u postgres psql <<EOF

CREATE DATABASE $DB_NAME;

CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';

GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;

EOF



echo ""
echo "[6/7] Saving configuration..."



cat > /opt/lak-panel/.env <<EOF

APP_PORT=$PANEL_PORT

DB_NAME=$DB_NAME

DB_USER=$DB_USER

DB_PASSWORD=$DB_PASS

SUPERADMIN=$SUPERADMIN

SUPERADMIN_PASSWORD=$ADMIN_PASS

EOF



echo ""
echo "[7/7] Installation completed"


echo ""
echo "================================="
echo " LAK PANEL INSTALLED"
echo "================================="

echo ""
echo "Panel Port:"
echo $PANEL_PORT

echo ""
echo "Admin:"
echo $SUPERADMIN

echo ""
