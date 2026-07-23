#!/usr/bin/env bash

set -Eeuo pipefail


#############################################
# Variables
#############################################

PROJECT_NAME="l-panel"

INSTALL_DIR="/opt/l-panel"

BIN_PATH="/usr/local/bin/l-panel"

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

BASE_DIR="$CURRENT_DIR"   # اضافه شد برای استفاده در اسکریپت‌ها



#############################################
# Root Check
#############################################

if [[ $EUID -ne 0 ]]; then
    echo "Please run as root."
    exit 1
fi



#############################################
# Install Files
#############################################

install_files(){

    echo
    echo "Installing L-Panel files..."

    mkdir -p "$INSTALL_DIR"

    cp -a "$CURRENT_DIR"/. "$INSTALL_DIR"/

    echo "Files copied."
}



#############################################
# Set Permissions
#############################################

set_permissions(){

    echo
    echo "Setting permissions..."

    chmod +x "$INSTALL_DIR/cli/l-panel"
    chmod +x "$INSTALL_DIR/cli/commands/"*.sh
    chmod +x "$INSTALL_DIR/cli/lib/"*.sh

}



#############################################
# Create Command Link (SYMLINK ONLY)
#############################################

create_command(){

    echo
    echo "Creating l-panel command..."

    ln -sfn "$INSTALL_DIR/cli/l-panel" /usr/local/bin/l-panel

}



#############################################
# Create Version Files
#############################################

create_state(){

    mkdir -p "$INSTALL_DIR"

    if [[ ! -f "$INSTALL_DIR/VERSION" ]]; then
        echo "0.0.1" > "$INSTALL_DIR/VERSION"
    fi

    touch "$INSTALL_DIR/.installed"

    date "+%Y-%m-%d %H:%M:%S" > "$INSTALL_DIR/.last_update"
}



#############################################
# Install Components (NEW SECTION)
#############################################

install_components(){

    echo
    echo "======================================"
    echo " Installing L-Panel Components"
    echo "======================================"
    echo

    bash "$BASE_DIR/scripts/install-node.sh"
    bash "$BASE_DIR/scripts/install-python.sh"
    bash "$BASE_DIR/scripts/install-postgresql.sh"
    bash "$BASE_DIR/scripts/install-redis.sh"
    bash "$BASE_DIR/scripts/install-backend.sh"
    bash "$BASE_DIR/scripts/install-frontend.sh"
    bash "$BASE_DIR/scripts/build-frontend.sh"
    bash "$BASE_DIR/scripts/install-nginx.sh"

    echo
    echo "======================================"
    echo " Installation Completed"
    echo "======================================"
    echo
}



#############################################
# Finish
#############################################

finish(){

    echo
    echo "======================================"
    echo " L-Panel Installed Successfully"
    echo "======================================"
    echo
    echo "Run:"
    echo
    echo "l-panel"
    echo
}



#############################################
# Main
#############################################

main(){

    install_files
    set_permissions
    create_command
    create_state
    install_components   # ← بخش جدید اینجا اضافه شد
    finish
}

main
