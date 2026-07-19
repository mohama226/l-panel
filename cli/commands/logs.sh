#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

require_root

clear

title

while true
do

clear

title

echo
echo "=============================================="
echo "               LOG MANAGER"
echo "=============================================="
echo

echo "1) Ocserv Log"
echo "2) Ocserv Journal"
echo "3) Fail2Ban Log"
echo "4) System Journal"
echo "5) Kernel Log"
echo "6) Follow Ocserv Log"
echo "7) Clear Ocserv Log"
echo "0) Back"

echo

read -rp "Select option: " ACTION

case "$ACTION" in

1)

if [[ -f /var/log/ocserv/ocserv.log ]]; then

    tail -100 /var/log/ocserv/ocserv.log

else

    warn "Log file not found."

fi

pause

;;

2)

journalctl -u ocserv --no-pager -n 100

pause

;;

3)

if [[ -f /var/log/fail2ban.log ]]; then

    tail -100 /var/log/fail2ban.log

else

    warn "Fail2Ban log not found."

fi

pause

;;

4)

journalctl --no-pager -n 100

pause

;;

5)

dmesg | tail -100

pause

;;

6)
echo

info "Press CTRL+C to stop."

sleep 1

if [[ -f /var/log/ocserv/ocserv.log ]]; then

    tail -f /var/log/ocserv/ocserv.log

else

    fail "Ocserv log not found."

fi

pause

;;

7)

echo

read -rp "Clear Ocserv log? (y/n): " CONFIRM

if [[ "$CONFIRM" == "y" ]]; then

    : > /var/log/ocserv/ocserv.log 2>/dev/null || true

    ok "Log cleared."

fi

pause

;;

0)

break

;;

*)

warn "Invalid option."

sleep 1

;;

esac

done

exit 0
