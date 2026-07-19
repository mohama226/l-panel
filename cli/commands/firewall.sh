#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

require_root

INFO_FILE="/etc/l-panel/ocserv.info"

PORT=443

[[ -f "$INFO_FILE" ]] && source "$INFO_FILE"

clear

title

while true
do

clear

title

echo
echo "=============================================="
echo "            FIREWALL MANAGER"
echo "=============================================="
echo

echo "Current VPN Port : $PORT"

echo

echo "1) Show Firewall Status"

echo "2) Open VPN Port"

echo "3) Close VPN Port"

echo "4) Reload Firewall"

echo "5) List Open Ports"

echo "0) Back"

echo

read -rp "Select option: " ACTION

case "$ACTION" in

1)

    echo

    systemctl status firewalld --no-pager

    echo

    pause

    ;;

2)
        echo

        info "Opening TCP/${PORT}..."

        firewall-cmd --permanent --add-port=${PORT}/tcp

        info "Opening UDP/${PORT}..."

        firewall-cmd --permanent --add-port=${PORT}/udp

        firewall-cmd --reload

        echo

        ok "VPN port opened."

        pause

        ;;

    3)

        echo

        read -rp "Close TCP/UDP port ${PORT}? (y/n): " CONFIRM

        [[ "$CONFIRM" != "y" ]] && continue

        firewall-cmd --permanent --remove-port=${PORT}/tcp || true

        firewall-cmd --permanent --remove-port=${PORT}/udp || true

        firewall-cmd --reload

        echo

        ok "VPN port closed."

        pause

        ;;

    4)

        echo

        info "Reloading firewall..."

        firewall-cmd --reload

        echo

        ok "Firewall reloaded."

        pause

        ;;

    5)

        echo

        firewall-cmd --list-ports

        echo

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
