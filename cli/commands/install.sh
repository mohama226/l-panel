#!/usr/bin/env bash

set -Eeuo pipefail

INSTALL_DIR="/opt/l-panel"
CONFIG_DIR="/etc/l-panel"
LOG_DIR="/var/log/l-panel"

BIN="/usr/local/bin/l-panel"

VERSION_FILE="$INSTALL_DIR/VERSION"
INSTALLED_FILE="$INSTALL_DIR/.installed"
LAST_UPDATE="$INSTALL_DIR/.last_update"


pause(){

echo
read -rp "Press ENTER to continue..."

}



title(){

clear

echo
echo "==============================================="
echo "          L-PANEL INSTALL"
echo "==============================================="
echo

}



repair(){

echo
echo "[+] Repairing Installation..."
echo


mkdir -p "$CONFIG_DIR"
mkdir -p "$LOG_DIR"


if [[ -f "$INSTALL_DIR/cli/l-panel" ]]; then

chmod +x "$INSTALL_DIR/cli/l-panel"

else

echo "ERROR: Main CLI file missing"
pause
return

fi



chmod +x "$INSTALL_DIR/cli/commands/"*.sh 2>/dev/null || true

chmod +x "$INSTALL_DIR/cli/lib/"*.sh 2>/dev/null || true



ln -sf "$INSTALL_DIR/cli/l-panel" "$BIN"



touch "$INSTALLED_FILE"



echo
echo "Repair completed successfully."
echo

pause

}



reinstall_cli(){


echo
echo "[+] Reinstalling CLI files..."
echo


TMP="/tmp/l-panel-cli-reinstall"

rm -rf "$TMP"

mkdir -p "$TMP"



echo "Downloading latest CLI..."

curl -fsSL \
https://github.com/mohama226/l-panel/archive/refs/heads/main.zip \
-o "$TMP/update.zip"



unzip -qo "$TMP/update.zip" -d "$TMP"



if [[ -d "$TMP/l-panel-main/cli" ]]; then


rm -rf "$INSTALL_DIR/cli"

cp -rf "$TMP/l-panel-main/cli" "$INSTALL_DIR/"



else

echo
echo "ERROR: CLI source not found"
pause
return

fi



chmod +x "$INSTALL_DIR/cli/l-panel"

chmod +x "$INSTALL_DIR/cli/commands/"*.sh 2>/dev/null || true

chmod +x "$INSTALL_DIR/cli/lib/"*.sh 2>/dev/null || true



ln -sf "$INSTALL_DIR/cli/l-panel" "$BIN"



echo
echo "CLI reinstall completed."
echo


pause


}



title


if [[ $EUID -ne 0 ]]; then

echo "Please run as root."
exit 1

fi



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

repair

;;

2)

reinstall_cli

;;

3)

exit 0

;;

*)

echo "Invalid option."
pause

;;

esac



exit 0

fi



#################################
# Fresh Installation
#################################


echo
echo "[+] Fresh installation detected"
echo


mkdir -p "$CONFIG_DIR"
mkdir -p "$LOG_DIR"



touch "$INSTALLED_FILE"


date "+%Y-%m-%d %H:%M:%S" > "$LAST_UPDATE"



ln -sf "$INSTALL_DIR/cli/l-panel" "$BIN"



chmod +x "$INSTALL_DIR/cli/l-panel"



echo
echo "=============================================="
echo " L-PANEL INSTALL COMPLETED"
echo "=============================================="

echo

pause
