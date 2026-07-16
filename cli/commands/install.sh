#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

require_root

#############################################
# Variables
#############################################

PANEL_PORT=""
SUPERADMIN_USER=""
SUPERADMIN_PASS=""

#############################################
# Read Panel Port
#############################################

read_panel_port() {

    while true; do

        echo

        read -rp "Panel Port [8080]: " PANEL_PORT

        [[ -z "$PANEL_PORT" ]] && PANEL_PORT=8080

        if [[ "$PANEL_PORT" =~ ^[0-9]+$ ]]; then

            if (( PANEL_PORT >= 1 && PANEL_PORT <= 65535 )); then
                break
            fi

        fi

        fail "Invalid Port."

    done

}

#############################################
# Read Username
#############################################

read_admin_user() {

    while true; do

        echo

        read -rp "SuperAdmin Username: " SUPERADMIN_USER

        [[ -z "$SUPERADMIN_USER" ]] && continue

        break

    done

}

#############################################
# Read Password
#############################################

read_admin_password() {

    while true; do

        echo

        read -rsp "SuperAdmin Password: " PASS1

        echo

        read -rsp "Confirm Password: " PASS2

        echo

        if [[ "$PASS1" != "$PASS2" ]]; then

            fail "Passwords do not match."

            continue

        fi

        if [[ ${#PASS1} -lt 8 ]]; then

            fail "Password must be at least 8 characters."

            continue

        fi

        SUPERADMIN_PASS="$PASS1"

        break

    done

}
#############################################
# Main
#############################################

title

info "L-Panel Installation"

read_panel_port

read_admin_user

read_admin_password

echo

ok "Configuration Completed"

echo

echo "Panel Port        : $PANEL_PORT"

echo "SuperAdmin User   : $SUPERADMIN_USER"

echo

pause
