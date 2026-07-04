#!/bin/bash

set -e

REPO_URL="https://github.com/YOUR_USERNAME/lak-panel.git"
INSTALL_DIR="/opt/lak-panel"

echo "======================================"
echo " LAK Panel Installer v0.0.1"
echo "======================================"

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

echo "[1/8] Updating packages..."
apt-get update

echo "[2/8] Installing dependencies..."
apt-get install -y git python3 python3-pip python3-venv

if [ -d "$INSTALL_DIR" ]; then
    echo "[3/8] Removing old installation..."
    rm -rf "$INSTALL_DIR"
fi

echo "[4/8] Cloning project..."
git clone "$REPO_URL" "$INSTALL_DIR"

cd "$INSTALL_DIR/backend"

echo "[5/8] Creating virtual environment..."
python3 -m venv venv

source venv/bin/activate

echo "[6/8] Installing python packages..."
pip install --upgrade pip

pip install -r requirements.txt

echo "[7/8] Creating .env..."

cp .env.example .env

echo "[8/8] Starting application..."

nohup venv/bin/python run.py > /tmp/lak-panel.log 2>&1 &

sleep 3

IP=$(hostname -I | awk '{print $1}')

echo ""
echo "======================================"
echo "LAK Panel Installed Successfully"
echo ""
echo "Open:"
echo ""
echo "http://$IP:8000"
echo ""
echo "======================================"
