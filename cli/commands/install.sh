#!/usr/bin/env bash

set -Eeuo pipefail


#####################################
# L-PANEL INSTALLER
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
# Root check
#####################################


if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Run as root"
    exit 1
fi



#####################################
# Detect package manager
#####################################


if command -v dnf >/dev/null 2>&1
then
    PM="dnf"

elif command -v yum >/dev/null 2>&1
then
    PM="yum"

else
    echo "No supported package manager found"
    exit 1
fi



#####################################
# Check existing
#####################################


if [[ -f "$INSTALLED_FILE" ]]
then

echo
echo "L-Panel is already installed."
echo
echo "Use Update option instead."
echo

exit 0

fi



#####################################
# Install dependencies
#####################################


echo
echo "[+] Installing dependencies..."


$PM install -y \
curl \
wget \
unzip \
tar \
rsync \
openssl \
firewalld



#####################################
# Create directories
#####################################


echo
echo "[+] Creating directories..."


mkdir -p "$INSTALL_DIR"
mkdir -p "$CONFIG_DIR"
mkdir -p "$LOG_DIR"



#####################################
# Panel settings
#####################################


echo
echo "================================="
echo " Panel Configuration"
echo "================================="
echo


read -rp "Panel Port [8080]: " PANEL_PORT

PANEL_PORT=${PANEL_PORT:-8080}



read -rp "Superadmin Username [admin]: " ADMIN_USER

ADMIN_USER=${ADMIN_USER:-admin}



while true
do

read -rsp "Superadmin Password: " ADMIN_PASS

echo

read -rsp "Confirm Password: " ADMIN_PASS2

echo


if [[ "$ADMIN_PASS" == "$ADMIN_PASS2" ]]
then
    break
fi


echo
echo "Passwords do not match"
echo

done



#####################################
# Save configuration
#####################################


echo "$PANEL_PORT" \
> "$INSTALL_DIR/.panel_port"


echo "$ADMIN_USER" \
> "$INSTALL_DIR/.admin_user"



cat > "$CONFIG_DIR/config" <<EOF
PANEL_PORT=$PANEL_PORT
ADMIN_USER=$ADMIN_USER
EOF



#####################################
# Version
#####################################


if [[ ! -f "$VERSION_FILE" ]]
then

echo "0.0.1" > "$VERSION_FILE"

fi



#####################################
# Installed flag
#####################################


touch "$INSTALLED_FILE"


date "+%Y-%m-%d %H:%M:%S" \
> "$LAST_UPDATE"



#####################################
# Permissions
#####################################


echo
echo "[+] Setting permissions..."


chmod +x "$INSTALL_DIR/cli/l-panel" 2>/dev/null || true


chmod +x "$INSTALL_DIR/cli/commands/"*.sh 2>/dev/null || true


chmod +x "$INSTALL_DIR/cli/lib/"*.sh 2>/dev/null || true



#####################################
# Create command
#####################################


echo
echo "[+] Creating l-panel command..."


ln -sf \
"$INSTALL_DIR/cli/l-panel" \
"$BIN"



#####################################
# Firewall
#####################################


systemctl enable firewalld --now >/dev/null 2>&1 || true


firewall-cmd \
--permanent \
--add-port="${PANEL_PORT}/tcp" \
>/dev/null 2>&1 || true


firewall-cmd --reload >/dev/null 2>&1 || true



#####################################
# Finish
#####################################


echo

echo "======================================"
echo " L-Panel Installed Successfully"
echo "======================================"

echo

echo "Version:"
cat "$VERSION_FILE"

echo

echo "Panel Port:"
cat "$INSTALL_DIR/.panel_port"

echo

echo "Admin User:"
cat "$INSTALL_DIR/.admin_user"


echo

echo "Run:"
echo

echo "l-panel"

echo


read -rp "Press ENTER to continue..."
