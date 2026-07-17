#!/usr/bin/env bash

set -Eeuo pipefail


#############################################
# L-PANEL Update Manager
#############################################


REPO="mohama226/l-panel"

BRANCH="main"

INSTALL_DIR="/opt/l-panel"

TMP_DIR="/tmp/l-panel-update"

BACKUP_DIR="/opt/l-panel-backups"


#############################################
# Load Libraries
#############################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BASE_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"


source "$BASE_DIR/cli/lib/colors.sh"
source "$BASE_DIR/cli/lib/common.sh"


#############################################
# Start
#############################################

clear

title


echo

echo "=============================================="

echo "          L-PANEL UPDATE"

echo "=============================================="

echo



#############################################
# Previous Update
#############################################


echo "Last Update:"

if [[ -f "$INSTALL_DIR/.last_update" ]]; then

    cat "$INSTALL_DIR/.last_update"

else

    echo "Never"

fi


echo


#############################################
# Confirm
#############################################


read -rp "Continue update? (y/n): " CONFIRM


if [[ "$CONFIRM" != "y" ]]; then

    echo "Cancelled"

    exit 0

fi



#############################################
# Prepare
#############################################


rm -rf "$TMP_DIR"

mkdir -p "$TMP_DIR"

mkdir -p "$BACKUP_DIR"



#############################################
# Backup
#############################################


BACKUP_FILE="$BACKUP_DIR/l-panel-$(date +%Y%m%d-%H%M%S).tar.gz"


echo

echo "[+] Creating backup..."

tar -czf "$BACKUP_FILE" \
    -C /opt \
    l-panel



echo

echo "Backup created:"

echo "$BACKUP_FILE"



#############################################
# Download
#############################################


echo

echo "[+] Downloading latest version..."


curl -fsSL \
"https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz" \
-o "$TMP_DIR/update.tar.gz"



tar -xzf "$TMP_DIR/update.tar.gz" \
-C "$TMP_DIR"



NEW_DIR=$(find "$TMP_DIR" -maxdepth 1 -type d -name "l-panel-*")



#############################################
# Compare Files
#############################################


echo

echo "Changed files:"

echo "--------------------------------"


FILES=$(diff -qr "$INSTALL_DIR" "$NEW_DIR" 2>/dev/null \
| grep "Files" \
| awk '{print $2}')


COUNT=$(echo "$FILES" | grep -c "/" || true)



if [[ "$COUNT" -eq 0 ]]; then

    echo "No changes detected."

else


    echo "Total changed files: $COUNT"

    echo


    echo "$FILES"


fi



echo

read -rp "Apply update? (y/n): " APPLY


if [[ "$APPLY" != "y" ]]; then

    echo "Update stopped."

    exit 0

fi



#############################################
# Update Files
#############################################


echo

echo "[+] Updating files..."



rsync -av \
--exclude=".git" \
"$NEW_DIR/" \
"$INSTALL_DIR/" \
> "$TMP_DIR/rsync.log"



#############################################
# Permissions
#############################################


echo

echo "[+] Fix permissions..."



chmod +x "$INSTALL_DIR/cli/l-panel"

chmod +x "$INSTALL_DIR/cli/commands/"*.sh

chmod +x "$INSTALL_DIR/cli/lib/"*.sh



#############################################
# Update Date
#############################################


save_last_update



#############################################
# Finish
#############################################


echo

echo "=============================================="

echo " L-PANEL UPDATED SUCCESSFULLY"

echo "=============================================="

echo

echo "Updated files: $COUNT"

echo

echo "Time:"

date


echo


pause
