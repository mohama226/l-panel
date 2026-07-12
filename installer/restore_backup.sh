#!/bin/bash


BASE="/opt/lak-panel"


echo "Available backups:"
echo


ls -lh $BASE/backup/backups/


echo

read -p "Backup filename: " FILE


if [ ! -f "$BASE/backup/backups/$FILE" ]

then

echo "File not found"

exit 1

fi



systemctl stop lak-panel



tar -xzf \
$BASE/backup/backups/$FILE \
-C /



systemctl daemon-reload

systemctl restart lak-panel



echo

echo "Restore completed"
