#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/version.sh"


title


echo
echo "=============================="
echo "        SYSTEM LOGS"
echo "=============================="
echo


echo "1) Ocserv Logs"
echo "2) L-Panel Logs"
echo "3) System Logs"
echo


read -rp "Select: " LOG


case "$LOG" in

1)
journalctl -u ocserv -n 50 --no-pager
;;

2)
journalctl -n 50 --no-pager | grep l-panel
;;

3)
journalctl -n 50 --no-pager
;;

*)
echo "Invalid"
;;

esac


pause
