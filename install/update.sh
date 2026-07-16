#!/bin/bash
set -e

PROJECT_DIR=$(cd "$(dirname "$0")/.."; pwd)
cd "$PROJECT_DIR"

echo "[+] Updating l-panel..."
git pull
pip3 install -r requirements.txt

date "+%Y-%m-%d %H:%M:%S" > last_update.txt

echo "[+] Updated."
