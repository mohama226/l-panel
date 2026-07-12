#!/bin/bash

set -e

BASE="/opt/lak-panel"

echo "======================================"
echo "        LAK PANEL INSTALLER"
echo "======================================"

echo ""
read -p "SuperAdmin Username: " ADMIN_USER
read -p "SuperAdmin Password: " ADMIN_PASS

echo ""
read -p "Panel Port [2096]: " PANEL_PORT

if [ -z "$PANEL_PORT" ]; then
 PANEL_PORT=2096
fi


echo ""
read -p "Install OCServ? (y/n): " INSTALL_OCSERV

echo ""
read -p "Enable Automatic Backup? (y/n): " INSTALL_BACKUP

echo ""
read -p "Enable Restore Manager? (y/n): " INSTALL_RESTORE

echo ""
read -p "Install Colob Script? (y/n): " INSTALL_COLOB


echo ""
echo "Installation Path:"
echo "$BASE"

mkdir -p $BASE


apt update

apt install -y \
python3 \
python3-venv \
python3-pip \
sqlite3 \
curl \
wget


echo "Copying panel files..."


cd $BASE/backend


python3 -m venv venv

source venv/bin/activate


pip install --upgrade pip

pip install -r requirements.txt


cat > $BASE/backend/.env <<EOF

ADMIN_USERNAME=$ADMIN_USER
ADMIN_PASSWORD=$ADMIN_PASS
PORT=$PANEL_PORT

EOF



echo "Creating systemd service..."


cat > /etc/systemd/system/lak-panel.service <<EOF

[Unit]
Description=LAK Panel
After=network.target


[Service]

WorkingDirectory=$BASE/backend

ExecStart=$BASE/backend/venv/bin/python3 $BASE/backend/run.py --port $PANEL_PORT

Restart=always

User=root


[Install]

WantedBy=multi-user.target

EOF


systemctl daemon-reload

systemctl enable lak-panel

systemctl restart lak-panel


if [ "$INSTALL_OCSERV" = "y" ]; then

bash $BASE/installer/install_ocserv.sh

fi


if [ "$INSTALL_BACKUP" = "y" ]; then

bash $BASE/installer/install_backup.sh

fi


if [ "$INSTALL_RESTORE" = "y" ]; then

bash $BASE/installer/install_restore.sh

fi


if [ "$INSTALL_COLOB" = "y" ]; then

bash $BASE/installer/install_colob.sh

fi



echo ""
echo "======================================"
echo " LAK PANEL INSTALLED"
echo ""
echo "Path:"
echo "$BASE"
echo ""
echo "Port:"
echo "$PANEL_PORT"
echo ""
echo "URL:"
echo "http://SERVER-IP:$PANEL_PORT"
echo "======================================"
