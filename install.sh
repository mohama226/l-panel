#!/bin/bash

set -e


REPO="https://github.com/mohama226/l-panel.git"

INSTALL_DIR="/opt/l-panel"


echo "================================="
echo "       L-PANEL INSTALLER"
echo "================================="


if [ -d "$INSTALL_DIR/.git" ]; then

    echo "[OK] Existing installation found"

    cd "$INSTALL_DIR"

    git pull

else

    echo "[OK] Downloading L-Panel"

    rm -rf "$INSTALL_DIR"

    git clone "$REPO" "$INSTALL_DIR"

fi


cd "$INSTALL_DIR"


chmod +x installer/*.sh


bash installer/main.sh
