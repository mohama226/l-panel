#!/bin/bash


BASE="/opt/lak-panel"


echo "Backup list:"

ls -1 $BASE/backup/backups/


echo

read -p "Enter backup name: " FILE



systemctl stop lak-panel



tar -xzf \
$BASE/backup/backups/$FILE \
-C /



systemctl daemon-reload


systemctl start lak-panel



echo "Restore Finished"
