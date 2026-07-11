#!/bin/bash

echo
echo "================================="
echo " LAK PANEL INITIAL CONFIG"
echo "================================="
echo


read -rp "Panel Port [2096]: " PANEL_PORT

if [ -z "$PANEL_PORT" ]; then
    PANEL_PORT=2096
fi


read -rp "SuperAdmin Username [admin]: " ADMIN_USER

if [ -z "$ADMIN_USER" ]; then
    ADMIN_USER=admin
fi


read -rsp "SuperAdmin Password: " ADMIN_PASS
echo


if [ -z "$ADMIN_PASS" ]; then
    echo "Password cannot be empty"
    exit 1
fi


cat > /opt/lak-panel/backend/.env <<EOF

APP_NAME=LAK Panel

APP_VERSION=0.1.0-alpha

APP_HOST=0.0.0.0

APP_PORT=$PANEL_PORT

SECRET_KEY=$(openssl rand -hex 32)

DATABASE_URL=sqlite:///./database.db

LOG_LEVEL=INFO

OC_SERV_USERS_FILE=/etc/ocserv/ocpasswd

ADMIN_USERNAME=$ADMIN_USER

ADMIN_PASSWORD=$ADMIN_PASS

EOF


echo "Configuration saved"
