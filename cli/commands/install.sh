#!/usr/bin/env bash

set -Eeuo pipefail


#####################################
# L-PANEL INSTALL / REPAIR
#####################################


INSTALL_DIR="/opt/l-panel"
CONFIG_DIR="/etc/l-panel"
LOG_DIR="/var/log/l-panel"

BIN="/usr/local/bin/l-panel"

VERSION_FILE="$INSTALL_DIR/VERSION"
INSTALLED_FILE="$INSTALL_DIR/.installed"
LAST_UPDATE="$INSTALL_DIR/.last_update"



clear

echo
echo "==============================================="
echo "          L-PANEL INSTALL"
echo "==============================================="
echo


#####################################
# ROOT CHECK
#####################################

if [[ $EUID -ne 0 ]]; then
    echo "Please run as root."
    exit 1
fi



#####################################
# Package manager
#####################################

if command -v dnf >/dev/null 2>&1; then
    PM="dnf"
elif command -v yum >/dev/null 2>&1; then
    PM="yum"
else
    echo "Unsupported system."
    exit 1
fi



#####################################
# Existing installation
#####################################

if [[ -f "$INSTALLED_FILE" ]]; then

    echo
    echo "L-Panel is already installed."
    echo

    echo "Current Version:"
    
    if [[ -f "$VERSION_FILE" ]]; then
        cat "$VERSION_FILE"
    else
        echo "Unknown"
    fi


    echo

    echo "Last Update:"

    if [[ -f "$LAST_UPDATE" ]]; then
        cat "$LAST_UPDATE"
    else
        echo "Never"
    fi


    echo
    echo "=============================================="
    echo
    echo "1) Repair Installation"
    echo "2) Reinstall CLI Files"
    echo "3) Cancel"
    echo

    read -rp "Select option: " ACTION


    case "$ACTION" in


        1)

        echo
        echo "[+] Repairing..."

        mkdir -p \
        "$CONFIG_DIR" \
        "$LOG_DIR"

        chmod +x "$INSTALL_DIR/cli/l-panel"

        chmod +x \
        "$INSTALL_DIR/cli/commands/"*.sh \
        2>/dev/null || true


        ln -sf \
        "$INSTALL_DIR/cli/l-panel" \
        "$BIN"


        echo
        echo "Repair completed."

        ;;


        2)

        echo
        echo "Use Update option to download latest files."

        ;;


        *)

        echo
        echo "Cancelled."

        ;;

    esac


    exit 0

fi




#####################################
# First Installation
#####################################


echo "[+] Creating directories..."


mkdir -p \
"$INSTALL_DIR" \
"$CONFIG_DIR" \
"$LOG_DIR"



#####################################
# Dependencies
#####################################


echo
echo "[+] Checking dependencies..."


PACKAGES=(
curl
wget
unzip
tar
rsync
)


for pkg in "${PACKAGES[@]}"
do

    if ! command -v "$pkg" >/dev/null 2>&1
    then

        echo "Installing $pkg"

        $PM install -y "$pkg"

    fi

done




#####################################
# Permission
#####################################


echo
echo "[+] Setting permissions..."


chmod +x "$INSTALL_DIR/cli/l-panel"

chmod +x \
"$INSTALL_DIR/cli/commands/"*.sh \
2>/dev/null || true


chmod +x \
"$INSTALL_DIR/cli/lib/"*.sh \
2>/dev/null || true



#####################################
# Command
#####################################


echo
echo "[+] Creating command..."


ln -sf \
"$INSTALL_DIR/cli/l-panel" \
"$BIN"




#####################################
# Mark installed
#####################################


touch "$INSTALLED_FILE"


date "+%Y-%m-%d %H:%M:%S" \
> "$LAST_UPDATE"



#####################################
# Finish
#####################################


echo

echo "======================================"
echo " L-PANEL INSTALL COMPLETED"
echo "======================================"

echo

echo "Run:"
echo

echo "l-panel"

echo

read -rp "Press ENTER to continue..."
