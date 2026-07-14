#!/bin/bash
set -e

BASE="/opt/l-panel"
OCSERV_DIR="/etc/ocserv"

echo "=============================="
echo " L-PANEL OCServ Installer"
echo " OCServ 1.5.0"
echo " ZIP CONFIG MODE"
echo "=============================="


apt update

apt install -y ocserv openssl


echo "[1] Creating config directory..."

mkdir -p $OCSERV_DIR


echo "[2] Installing L-Panel config..."


if [ -f "$BASE/installer/files/ocserv/ocserv.conf" ]; then

cp "$BASE/installer/files/ocserv/ocserv.conf" \
$OCSERV_DIR/ocserv.conf

else

echo "ERROR: ocserv.conf missing"
exit 1

fi


echo "[3] Creating certificates..."

if [ ! -f "$OCSERV_DIR/server-key.pem" ]; then

openssl req -x509 -nodes \
-newkey rsa:4096 \
-keyout $OCSERV_DIR/server-key.pem \
-out $OCSERV_DIR/server-cert.pem \
-days 3650 \
-subj "/CN=L-PANEL OCServ"

fi


echo "[4] Creating password file..."

if [ ! -f "$OCSERV_DIR/ocpasswd" ]; then

touch $OCSERV_DIR/ocpasswd

fi


echo "[5] Installing service..."

if [ -f "$BASE/installer/systemd/ocserv.service" ]; then

cp "$BASE/installer/systemd/ocserv.service" \
/etc/systemd/system/ocserv.service

fi


systemctl daemon-reload

systemctl enable ocserv

systemctl restart ocserv


echo ""
echo "=============================="
echo " OCServ Installed"
echo " Config:"
echo "$OCSERV_DIR/ocserv.conf"
echo "=============================="
