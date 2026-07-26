#!/bin/bash

set -e


INSTALLER_DIR="/tmp/lpanel-installer"


cd /root


rm -rf "$INSTALLER_DIR"


mkdir -p "$INSTALLER_DIR"


dnf install -y git curl wget unzip >/dev/null


echo "[OK] Base packages installed"


git clone https://github.com/mohama226/l-panel.git "$INSTALLER_DIR"


cd "$INSTALLER_DIR"


source installer/functions.sh
source installer/main.sh
