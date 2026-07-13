#!/usr/bin/env bash

set -e

REPO="https://github.com/YOUR_USERNAME/l-panel.git"
INSTALL_DIR="/opt/l-panel"

echo "=================================="
echo "       L-PANEL INSTALLER"
echo "=================================="

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

echo "[1/9] Updating packages..."
apt update

echo "[2/9] Installing packages..."
apt install -y git python3 python3-venv python3-pip

if [ ! -d "$INSTALL_DIR" ]; then
    echo "[3/9] Cloning project..."
    git clone "$REPO" "$INSTALL_DIR"
else
    echo "[3/9] Project already exists."
fi

cd "$INSTALL_DIR"

echo "[4/9] Creating virtual environment..."
python3 -m venv venv

echo "[5/9] Installing python packages..."
source venv/bin/activate

pip install --upgrade pip

pip install -r requirements.txt

echo "[6/9] Setting permissions..."
chmod +x run.py
chmod +x install.sh

echo "[7/9] Installing systemd service..."
cp installer/l-panel.service /etc/systemd/system/l-panel.service

systemctl daemon-reload
systemctl enable l-panel

echo "[8/9] Starting service..."
systemctl restart l-panel

echo "[9/9] Done."

IP=$(hostname -I | awk '{print $1}')

echo ""
echo "=================================="
echo "L-PANEL Installed Successfully"
echo ""
echo "Open:"
echo "http://$IP:2096"
echo "=================================="
