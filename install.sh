#!/bin/bash

set -e

APP_DIR="/opt/l-panel"

echo "======================"
echo " L-PANEL INSTALL"
echo "======================"


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
nginx


elif command -v dnf >/dev/null 2>&1
then

echo "Detected AlmaLinux/RHEL"


dnf install -y \
python3 \
python3-pip \
python3-virtualenv \
git \
curl \
nginx


systemctl enable nginx
systemctl start nginx


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



if [ ! -d "$APP_DIR" ]
then

git clone https://github.com/mohama226/l-panel.git $APP_DIR

fi



cd $APP_DIR/backend



python3 -m venv venv


source venv/bin/activate


pip install --upgrade pip


pip install -r requirements.txt



cat >/etc/systemd/system/l-panel.service <<EOF

[Unit]
Description=L-PANEL
After=network.target


[Service]
WorkingDirectory=/opt/l-panel/backend
ExecStart=/opt/l-panel/backend/venv/bin/gunicorn -w 2 -b 0.0.0.0:2096 app:app
Restart=always


[Install]
WantedBy=multi-user.target

EOF



systemctl daemon-reload

systemctl enable l-panel

systemctl restart l-panel



if command -v firewall-cmd >/dev/null 2>&1
then

firewall-cmd --permanent --add-port=2096/tcp
firewall-cmd --reload

fi



echo ""
echo "======================"
echo " L-PANEL READY"
echo "======================"
echo ""
echo "Open:"
echo "http://SERVER-IP:2096"
echo ""
echo "Login:"
echo "admin"
echo "admin123"
