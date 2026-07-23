#!/bin/bash

set -e

APP_DIR="/opt/l-panel"

echo "======================"
echo " L-PANEL INSTALL"
echo "======================"

apt update

apt install -y python3 python3-pip python3-venv git postgresql postgresql-contrib nginx

if [ ! -d "$APP_DIR" ]; then
    git clone https://github.com/mohama226/l-panel.git $APP_DIR
fi

cd $APP_DIR

python3 -m venv venv

source venv/bin/activate

pip install --upgrade pip

pip install -r requirements.txt


systemctl enable postgresql
systemctl start postgresql


sudo -u postgres psql <<EOF
CREATE USER lpanel WITH PASSWORD 'lpanel123';
CREATE DATABASE lpanel OWNER lpanel;
EOF


cat > /etc/systemd/system/lpanel.service <<EOF
[Unit]
Description=L-Panel
After=network.target

[Service]
WorkingDirectory=/opt/l-panel
ExecStart=/opt/l-panel/venv/bin/python /opt/l-panel/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl enable lpanel
systemctl restart lpanel


echo ""
echo "======================"
echo " INSTALL COMPLETE"
echo " Panel:"
echo " http://SERVER-IP:5000"
echo "======================"
