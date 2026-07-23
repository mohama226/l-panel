#!/bin/bash

set -e

APP_DIR="/opt/l-panel"
REPO="https://github.com/mohama226/l-panel.git"
PORT="2096"


echo "======================"
echo " L-PANEL INSTALL"
echo "======================"


# Detect OS

if command -v apt >/dev/null 2>&1
then

    echo "Detected Ubuntu/Debian"

    apt update

    apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    curl \
    nginx \
    ufw


elif command -v dnf >/dev/null 2>&1
then

    echo "Detected AlmaLinux/RHEL"

    dnf install -y \
    python3 \
    python3-pip \
    python3-virtualenv \
    git \
    curl \
    nginx \
    firewalld


    systemctl enable firewalld
    systemctl start firewalld


elif command -v yum >/dev/null 2>&1
then

    echo "Detected CentOS"

    yum install -y \
    python3 \
    python3-pip \
    python3-virtualenv \
    git \
    curl \
    nginx


else

    echo "Unsupported Linux"

    exit 1

fi



# Clone project

if [ ! -d "$APP_DIR" ]
then

    git clone $REPO $APP_DIR

else

    echo "Project exists"

fi



cd $APP_DIR



# Find application directory

if [ -f "$APP_DIR/app.py" ]
then

    APP_PATH="$APP_DIR"

elif [ -f "$APP_DIR/backend/app.py" ]
then

    APP_PATH="$APP_DIR/backend"

else

    echo "ERROR:"
    echo "app.py not found"

    exit 1

fi



echo "Application path:"
echo $APP_PATH



cd $APP_PATH



# Create virtualenv

if [ ! -d "venv" ]
then

    python3 -m venv venv

fi



source venv/bin/activate



pip install --upgrade pip



if [ -f requirements.txt ]
then

    pip install -r requirements.txt

else

    pip install flask gunicorn

fi



# Create systemd service


cat >/etc/systemd/system/l-panel.service <<EOF

[Unit]
Description=L-PANEL
After=network.target


[Service]
Type=simple

WorkingDirectory=$APP_PATH

ExecStart=$APP_PATH/venv/bin/gunicorn \
-w 2 \
-b 0.0.0.0:$PORT \
app:app

Restart=always


[Install]
WantedBy=multi-user.target

EOF



systemctl daemon-reload

systemctl enable l-panel

systemctl restart l-panel



# Firewall

if command -v firewall-cmd >/dev/null 2>&1
then

    firewall-cmd --permanent --add-port=${PORT}/tcp
    firewall-cmd --reload

fi



if command -v ufw >/dev/null 2>&1
then

    ufw allow ${PORT}/tcp || true

fi



echo ""
echo "======================"
echo " L-PANEL READY"
echo "======================"
echo ""
echo "URL:"
echo "http://SERVER-IP:$PORT"
echo ""
echo "Check status:"
echo "systemctl status l-panel"
echo ""
