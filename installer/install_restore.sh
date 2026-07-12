#!/bin/bash

set -e


BASE_DIR="/opt/lak-panel"

BACKUP_DIR="$BASE_DIR/backups"


echo "================================="
echo " LAK PANEL RESTORE INSTALLER"
echo "================================="


mkdir -p "$BASE_DIR/scripts"



cat > "$BASE_DIR/scripts/restore.sh" <<'EOF'

#!/bin/bash


BASE="/opt/lak-panel"

BACKUP="/opt/lak-panel/backups"



echo "================================="
echo " LAK PANEL RESTORE"
echo "================================="


echo ""

echo "Available backups:"
echo ""


ls -1 "$BACKUP"/*.tar.gz 2>/dev/null



echo ""

read -p "Backup file name: " FILE



if [ ! -f "$BACKUP/$FILE" ]; then

echo "Backup not found"

exit 1

fi



TMP="/tmp/lak-restore"


rm -rf "$TMP"

mkdir -p "$TMP"



echo "Extracting backup..."

tar -xzf "$BACKUP/$FILE" -C "$TMP"



DIR=$(find "$TMP" -maxdepth 1 -type d | tail -1)



echo "Restoring database..."

if [ -f "$DIR/database.db" ]; then

cp "$DIR/database.db" \
"$BASE/backend/database.db"

fi



echo "Restoring environment..."

if [ -f "$DIR/.env" ]; then

cp "$DIR/.env" \
"$BASE/backend/.env"

fi



echo "Restoring OCServ..."

if [ -f "$DIR/ocserv.conf" ]; then

cp "$DIR/ocserv.conf" \
/etc/ocserv/ocserv.conf

systemctl restart ocserv

fi



echo "Restarting LAK Panel..."

systemctl restart lak-panel



echo ""

echo "Restore completed"

EOF



chmod +x "$BASE_DIR/scripts/restore.sh"



echo ""

echo "Restore system installed"

echo ""

echo "Command:"

echo "/opt/lak-panel/scripts/restore.sh"
