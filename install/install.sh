#!/usr/bin/env bash

########################################
# L-PANEL Bootstrap Installer
########################################

set -e

INSTALL_DIR="/opt/l-panel"

REPO_URL="https://github.com/mohama226/l-panel.git"

BRANCH="main"

echo "========================================"
echo "        L-PANEL INSTALLER"
echo "========================================"

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

apt update

while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1
do
    echo "Waiting for apt..."
    sleep 5
done

apt install -y git

if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
fi

git clone -b "$BRANCH" "$REPO_URL" "$INSTALL_DIR"

chmod -R +x "$INSTALL_DIR/install"

chmod -R +x "$INSTALL_DIR/cli"

exec bash "$INSTALL_DIR/install/setup.sh"
