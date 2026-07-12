#!/bin/bash

set -e

ZIP_URL="https://github.com/mohama226/lak-panel/releases/latest/download/lak-panel.zip"

BASE="/opt/lak-panel"


echo "================================="
echo "       LAK PANEL INSTALL"
echo "================================="


apt update

apt install -y curl unzip python3 python3-venv python3-pip nginx


echo "Downloading package..."

rm -rf /tmp/lak-panel

mkdir -p /tmp/lak-panel


curl -L "$ZIP_URL" \
-o /tmp/lak-panel.zip


echo "Extracting..."


unzip -o /tmp/lak-panel.zip \
-d /tmp/lak-panel



echo "Installing files..."


rm -rf $BASE


mkdir -p $BASE


cp -r /tmp/lak-panel/* $BASE/


echo "Creating venv..."


python3 -m venv \
$BASE/backend/venv



echo "Installing python packages..."


$BASE/backend/venv/bin/pip install --upgrade pip


$BASE/backend/venv/bin/pip install \
-r $BASE/backend/requirements.txt



echo "Installing systemd..."


cp \
$BASE/systemd/lak-panel.service \
/etc/systemd/system/lak-panel.service



echo "Installing command..."


cp \
$BASE/scripts/lak-panel \
/usr/local/bin/lak-panel


chmod +x /usr/local/bin/lak-panel



systemctl daemon-reload

systemctl enable lak-panel

systemctl restart lak-panel



echo ""
echo "INSTALL FINISHED"

systemctl status lak-panel --no-pager
