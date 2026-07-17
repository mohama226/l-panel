#!/usr/bin/env bash

set -Eeuo pipefail


INSTALL_DIR="/opt/l-panel"
BACKUP_DIR="/opt/l-panel-backups"

REPO="mohama226/l-panel"
BRANCH="main"

TMP_DIR="/tmp/l-panel-update"

DATE=$(date +"%Y%m%d-%H%M%S")


clear

echo "==============================================="
echo "          L-PANEL UPDATE"
echo "==============================================="

echo

if [[ -f "$INSTALL_DIR/.last_update" ]]; then
    echo "Last Update:"
    cat "$INSTALL_DIR/.last_update"
else
    echo "Last Update: Never"
fi

echo

read -rp "Continue update? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" ]]; then
    exit 0
fi


#################################
# Backup
#################################

echo
echo "[+] Creating backup..."

mkdir -p "$BACKUP_DIR"

tar -czf \
"$BACKUP_DIR/l-panel-$DATE.tar.gz" \
-C /opt l-panel

echo
echo "Backup created:"
echo "$BACKUP_DIR/l-panel-$DATE.tar.gz"


#################################
# Download
#################################

echo
echo "[+] Downloading latest version..."

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

wget -q \
"https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" \
-O "$TMP_DIR/update.tar.gz"

tar -xzf \
"$TMP_DIR/update.tar.gz" \
-C "$TMP_DIR"

SOURCE=$(find "$TMP_DIR" -maxdepth 1 -type d -name "l-panel-*" | head -n1)

if [[ -z "$SOURCE" ]]; then
    echo "Source not found"
    exit 1
fi

if [[ ! -d "$SOURCE" ]]; then
    echo "Invalid source directory:"
    echo "$SOURCE"
    exit 1
fi

echo
echo "New source directory:"
echo "$SOURCE"


#################################
# Compare
#################################

echo
echo "Changed files:"
echo "--------------------------------"

mapfile -t FILES < <(
rsync \
-rcn \
--out-format="%n" \
"$SOURCE/" \
"$INSTALL_DIR/"
)

if [[ ${#FILES[@]} -eq 0 ]]; then
    echo "No changes detected."
else
    for FILE in "${FILES[@]}"
    do
        echo "$FILE"
    done
fi

echo
echo "Total changed files: ${#FILES[@]}"

echo
read -rp "Apply update? (y/n): " APPLY

if [[ "$APPLY" != "y" ]]; then
    exit 0
fi


#################################
# Update
#################################

echo
echo "[+] Updating files..."

rsync \
-r \
--delete \
"$SOURCE/" \
"$INSTALL_DIR/"


#################################
# Permissions
#################################

echo
echo "[+] Fix permissions..."

chmod +x "$INSTALL_DIR/cli/l-panel"
chmod +x "$INSTALL_DIR/cli/commands/"*.sh
chmod +x "$INSTALL_DIR/cli/lib/"*.sh


#################################
# Remove temporary files
#################################

rm -rf "$TMP_DIR"


#################################
# Save update time
#################################

date "+%Y-%m-%d %H:%M:%S" \
> "$INSTALL_DIR/.last_update"

echo
echo "=============================================="
echo " L-PANEL UPDATED SUCCESSFULLY"
echo "=============================================="
echo

echo "Updated files: ${#FILES[@]}"
echo

echo "Time:"
date

echo
read -rp "Press ENTER to continue..."
