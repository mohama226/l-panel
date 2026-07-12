#!/bin/bash

set -e

BASE="/opt/lak-panel"

echo "======================================"
echo "       LAK PANEL ZIP INSTALLER"
echo "======================================"

echo ""

read -p "SuperAdmin Username: " ADMIN_USER
read -s -p "SuperAdmin Password: " ADMIN_PASS
echo ""

read -p "Panel Port [2096]: " PANEL_PORT

if [ -z "$PANEL_PORT" ]; then
    PANEL_PORT=2096
fi


read -p "Install OCServ? (y/n): " INSTALL_OCSERV
read -p "Enable Backup System? (y/n): " INSTALL_BACKUP
read -p "Enable Restore System? (y/n): " INSTALL_RESTORE
read -p "Install Kolomb Script? (y/n): " INSTALL_KOLOMB


echo ""
echo "Installation Path:"
echo "$BASE"


apt update

apt install -y \
python3 \
python3-venv \
python3-pip \
sqlite3 \
curl \
wget \
unzip


rm -rf /tmp/lak-panel*

cd /tmp


wget -O lak-panel.zip \
https://github.com/mohama226/lak-panel/archive/refs/heads/main.zip


unzip -o lak-panel.zip


rm -rf $BASE

mv lak-panel-main $BASE


echo ""
echo "Installing Python Environment..."


cd $BASE/backend


python3 -m venv venv


source $BASE/backend/venv/bin/activate


pip install --upgrade pip

pip install -r requirements.txt


echo ""
echo "Initializing Database"


python3 init_db.py


echo ""
echo "Creating Admin"


python3 create_admin.py \
"$ADMIN_USER" \
"$ADMIN_PASS"



echo ""
echo "Creating ENV"


cat > $BASE/backend/.env <<EOF

ADMIN_USERNAME=$ADMIN_USER
ADMIN_PASSWORD=$ADMIN_PASS
PORT=$PANEL_PORT

EOF



echo ""
echo "Creating Systemd Service"



cat > /etc/systemd/system/lak-panel.service <<EOF

[Unit]
Description=LAK Panel
After=network.target


[Service]

Type=simple

WorkingDirectory=$BASE/backend

Environment=PYTHONUNBUFFERED=1

ExecStart=$BASE/backend/venv/bin/python3 $BASE/backend/run.py --port $PANEL_PORT

Restart=always

RestartSec=3

User=root


[Install]

WantedBy=multi-user.target

EOF



systemctl daemon-reload

systemctl enable lak-panel

systemctl restart lak-panel



mkdir -p /usr/local/bin


cat > /usr/local/bin/lak-panel <<EOF

#!/bin/bash
bash $BASE/scripts/menu.sh

EOF


chmod +x /usr/local/bin/lak-panel



if [ "$INSTALL_OCSERV" = "y" ]; then

bash $BASE/installer/install_ocserv.sh

fi


if [ "$INSTALL_BACKUP" = "y" ]; then

bash $BASE/installer/install_backup.sh

fi


if [ "$INSTALL_RESTORE" = "y" ]; then

bash $BASE/installer/install_restore.sh

fi


if [ "$INSTALL_KOLOMB" = "y" ]; then

bash $BASE/installer/install_kolomb.sh

fi



echo ""
echo "======================================"
echo " LAK PANEL INSTALLED"
echo ""
echo "PATH:"
echo "$BASE"
echo ""
echo "PORT:"
echo "$PANEL_PORT"
echo ""
echo "URL:"
echo "http://SERVER-IP:$PANEL_PORT"
echo ""
echo "COMMAND:"
echo "lak-panel"
echo "======================================"
