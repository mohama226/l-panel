#!/bin/bash

set -e


echo "=========================="
echo " LAK PANEL INSTALL"
echo "=========================="


read -p "Admin username: " ADMIN

read -s -p "Admin password: " PASS

echo


read -p "Panel port [2096]: " PORT

PORT=${PORT:-2096}



apt update -y


apt install -y \
python3 \
python3-venv \
python3-pip \
wget \
unzip


rm -rf /opt/lak-panel


mkdir -p /opt/lak-panel



echo "Installing files..."



# اینجا بعدا zip میاد
# فعلا برای تست


cp -r backend /opt/lak-panel/


cp -r systemd /opt/lak-panel/



cd /opt/lak-panel/backend



python3 -m venv venv


source venv/bin/activate


pip install -r requirements.txt



cat >/etc/systemd/system/lak-panel.service <<EOF

[Unit]
Description=LAK Panel
After=network.target


[Service]
WorkingDirectory=/opt/lak-panel/backend
ExecStart=/opt/lak-panel/backend/venv/bin/python run.py
Restart=always


[Install]
WantedBy=multi-user.target

EOF



systemctl daemon-reload

systemctl enable lak-panel

systemctl restart lak-panel



echo
echo "=========================="
echo " INSTALL COMPLETE"
echo "=========================="

echo "Open:"
echo "http://SERVER-IP:$PORT"
