#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

title

echo
echo "=============================================="
echo "          DISCONNECT USER"
echo "=============================================="
echo

if ! command -v occtl >/dev/null 2>&1; then

    fail "occtl command not found."

    pause

    exit 1

fi

if ! systemctl is-active ocserv >/dev/null 2>&1; then

    fail "Ocserv service is not running."

    pause

    exit 1

fi

echo

read -rp "Username : " USERNAME

USERNAME="$(echo "$USERNAME" | xargs)"

if [[ -z "$USERNAME" ]]; then

    fail "Username cannot be empty."

    pause

    exit 1

fi

SESSION_ID=$(
occtl show users 2>/dev/null | \
awk -v u="$USERNAME" '$0 ~ u {print $1;exit}'
)

if [[ -z "$SESSION_ID" ]]; then

    fail "User is not online."

    pause

    exit 1

fi

echo

echo "Session ID : $SESSION_ID"

echo

read -rp "Disconnect user? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" ]]; then

    warn "Cancelled."

    pause

    exit 0

fi

echo

info "Disconnecting user..."
if occtl disconnect id "$SESSION_ID"; then

    echo

    ok "User disconnected successfully."

else

    echo

    fail "Failed to disconnect user."

    pause

    exit 1

fi

echo

echo "=============================================="
echo "Username   : $USERNAME"
echo "Session ID : $SESSION_ID"
echo "Status     : Disconnected"
echo "=============================================="

echo

pause

exit 0
