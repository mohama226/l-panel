#!/bin/bash
set -e

cd /opt/l-panel

echo "[+] Updating l-panel..."
git pull
pip3 install -r requirements.txt
echo "[+] Updated."
