#!/bin/bash

set -e


BASE_DIR="/opt/lak-panel"

BACKUP_DIR="$BASE_DIR/backups"

mkdir -p "$BACKUP_DIR"


echo "================================="
echo " LAK PANEL BACKUP INSTALLER"
echo "================================="


echo ""


cat > "$BASE_DIR/scripts/backup.sh" <<'EOF'

#!/bin/bash


BASE="/opt/lak-panel"

BACKUP="/opt/lak-panel/backups"


DATE=$(date +"%Y-%m-%d_%H-%M-%S")


mkdir -p "$BACKUP/$DATE"


echo "Creating backup..."


# Database

if [ -f "$BASE/backend/database.db" ]; then

cp "$BASE/backend/database.db" \
"$BACKUP/$DATE/database.db"

fi



# Environment

if [ -f "$BASE/backend/.env" ]; then

cp "$BASE/backend/.env" \
"$BACKUP/$DATE/.env"

fi



# OCServ

if [ -f "/etc/ocserv/ocserv.conf" ]; then

cp /etc/ocserv/ocserv.conf \
"$BACKUP/$DATE/ocserv.conf"

fi



# Compress

cd "$BACKUP"

tar -czf "$DATE.tar.gz" "$DATE"


rm -rf "$BACKUP/$DATE"


echo "Backup created:"
echo "$BACKUP/$DATE.tar.gz"

EOF



chmod +x "$BASE_DIR/scripts/backup.sh"



echo "Creating automatic backup schedule..."



cat > /etc/cron.d/lak-panel-backup <<EOF

0 3 * * * root $BASE_DIR/scripts/backup.sh

EOF



echo ""

echo "Backup system installed"

echo ""

echo "Backup path:"

echo "$BACKUP_DIR"
