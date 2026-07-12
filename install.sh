#!/bin/bash

set -e


clear


echo "=============================="
echo "       LAK PANEL INSTALL"
echo "=============================="


if [ "$EUID" -ne 0 ]; then

echo "Run as root"

exit 1

fi



read -p "SuperAdmin username: " ADMIN


read -s -p "SuperAdmin password: " ADMIN_PASS

echo



read -p "Panel port [2096]: " PORT


PORT=${PORT:-2096}



echo

echo "Install ocserv 1.5?"

echo "1) Yes"

echo "2) No"


read OC



echo

read -p "Continue? (y/n): " CONFIRM



if [[ "$CONFIRM" != "y" ]]; then

exit 0

fi



BASE="/opt/lak-panel"



mkdir -p $BASE



echo "Installing dependencies..."

bash scripts/install_dependencies.sh



echo "Downloading panel..."



cd /tmp


wget -O lak-panel.zip \
https://github.com/USERNAME/lak-panel/releases/latest/download/lak-panel.zip



unzip -o lak-panel.zip -d $BASE



echo "Creating python environment"



cd $BASE/backend


python3 -m venv venv


source venv/bin/activate


pip install --upgrade pip


pip install -r requirements.txt
python -m pip install --upgrade pip


DB_NAME="lakpanel"

DB_USER="lakpanel"

DB_PASS=$(openssl rand -hex 20)



echo "Creating database"



bash $BASE/scripts/setup_postgresql.sh \
$DB_NAME \
$DB_USER \
$DB_PASS



cat > $BASE/.env <<EOF

APP_PORT=$PORT

DB_NAME=$DB_NAME

DB_USER=$DB_USER

DB_PASSWORD=$DB_PASS

ADMIN_USERNAME=$ADMIN

ADMIN_PASSWORD=$ADMIN_PASS

INSTALL_OCSERV=$OC

EOF



echo "Creating service"



bash $BASE/scripts/setup_service.sh



echo

echo "=============================="

echo "LAK PANEL READY"

echo "PORT : $PORT"

echo "ADMIN : $ADMIN"

echo "=============================="
