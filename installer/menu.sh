#!/bin/bash

BASE="/opt/lak-panel"

while true
do

clear

echo "========================================="
echo "          LAK PANEL MANAGER"
echo "              VERSION 1.0"
echo "========================================="

echo
echo "Install Path:"
echo "$BASE"

echo
echo "-----------------------------------------"
echo "1) Panel Status"
echo "2) Start Panel"
echo "3) Stop Panel"
echo "4) Restart Panel"
echo "5) View Logs"
echo
echo "6) Create Backup"
echo "7) Restore Backup"
echo
echo "8) Install OCServ"
echo "9) Remove OCServ"
echo
echo "10) Install Kolomb Script"
echo
echo "11) Update Panel"
echo
echo "0) Exit"
echo "-----------------------------------------"

echo

read -p "Select option: " option


case $option in


1)

systemctl status lak-panel --no-pager

read -p "Press Enter..."

;;


2)

systemctl start lak-panel

echo "Panel Started"

sleep 2

;;


3)

systemctl stop lak-panel

echo "Panel Stopped"

sleep 2

;;


4)

systemctl restart lak-panel

echo "Panel Restarted"

sleep 2

;;


5)

journalctl -u lak-panel -n 100 --no-pager

read -p "Press Enter..."

;;


6)

bash $BASE/backup/backup.sh

read -p "Press Enter..."

;;


7)

bash $BASE/backup/restore.sh

read -p "Press Enter..."

;;


8)

bash $BASE/installer/install_ocserv.sh

read -p "Press Enter..."

;;


9)

apt remove --purge ocserv -y

echo "OCServ removed"

sleep 2

;;


10)

bash $BASE/installer/install_kolomb.sh

read -p "Press Enter..."

;;


11)

cd $BASE

bash $BASE/installer/update.sh

read -p "Press Enter..."

;;


0)

exit

;;


*)

echo "Invalid option"

sleep 2

;;


esac


done
