#!/bin/bash

BASE_DIR="/opt/lak-panel"

INSTALLER_DIR="$BASE_DIR/installer"

SERVICE="lak-panel"


clear

while true
do

echo "========================================="
echo "              LAK PANEL MANAGER"
echo "              Version 1.0.0"
echo "========================================="

echo ""

echo " Installation Path:"
echo " $BASE_DIR"

echo ""

echo " 1) Install / Repair Panel"
echo " 2) Install OCServ"
echo " 3) Update Panel"
echo " 4) Restart Service"
echo " 5) Stop Service"
echo " 6) Start Service"
echo " 7) Service Status"
echo " 8) View Logs"
echo " 9) Create Backup"
echo "10) Restore Backup"
echo "11) Install Colob Script"
echo "12) Uninstall"

echo ""

echo " 0) Exit"

echo ""

read -p "Select option: " OPTION


case $OPTION in


1)

bash $INSTALLER_DIR/install_panel.sh

;;


2)

bash $INSTALLER_DIR/install_ocserv.sh

;;


3)

bash $INSTALLER_DIR/update.sh

;;


4)

systemctl restart $SERVICE

echo "Service restarted"

;;


5)

systemctl stop $SERVICE

echo "Service stopped"

;;


6)

systemctl start $SERVICE

echo "Service started"

;;


7)

systemctl status $SERVICE --no-pager -l

;;


8)

journalctl -u $SERVICE -n 100 --no-pager

;;


9)

bash $INSTALLER_DIR/install_backup.sh

;;


10)

bash $INSTALLER_DIR/install_restore.sh

;;


11)

bash $INSTALLER_DIR/install_colob.sh

;;


12)

bash $INSTALLER_DIR/uninstall.sh

;;


0)

exit 0

;;


*)

echo "Invalid option"

;;

esac


echo ""

read -p "Press Enter to continue..."

clear

done
