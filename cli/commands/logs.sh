#!/usr/bin/env bash

set -Eeuo pipefail


clear

title


echo
echo "=============================="
echo " SERVICE LOGS"
echo "=============================="
echo


echo "1) Ocserv logs"
echo "2) System logs"
echo "0) Back"

echo

read -rp "Select: " LOG


case "$LOG" in

1)

journalctl -u ocserv -n 100 --no-pager

;;

2)

journalctl -n 100 --no-pager

;;

0)

exit 0

;;

*)

echo "Invalid option"

;;

esac


pause
