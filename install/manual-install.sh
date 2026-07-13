#!/usr/bin/env bash

set -e

INSTALL_DIR="/opt/l-panel"

echo "========================================"
echo "      L-PANEL MANUAL INSTALLER"
echo "========================================"

if [ "$EUID" -ne 0 ]; then
    echo "Please run installer as root."
    exit 1
fi

CURRENT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

mkdir -p "$INSTALL_DIR"

cp -a "$CURRENT_DIR/." "$INSTALL_DIR/"

chmod -R +x "$INSTALL_DIR/install"
chmod -R +x "$INSTALL_DIR/cli"

exec bash "$INSTALL_DIR/install/setup.sh"
