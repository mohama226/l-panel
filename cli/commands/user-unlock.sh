#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

PASSWD_FILE="/etc/ocserv/ocpasswd"

title

echo
echo "=============================================="
echo "             UNLOCK USER"
echo "=============================================="
echo

if [[ ! -f "$PASSWD_FILE" ]]; then

    fail "ocpasswd file not found."

    pause
    exit 1

fi

read -rp "Username : " USERNAME

USERNAME="$(echo "$USERNAME" | xargs)"

if [[ -z "$USERNAME" ]]; then

    fail "Username cannot be empty."

    pause
    exit 1

fi

if ! grep -q "^!${USERNAME}:" "$PASSWD_FILE"; then

    fail "Locked user not found."

    pause
    exit 1

fi

echo
read -rp "Unlock this user? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" ]]; then

    warn "Cancelled."

    pause
    exit 0

fi

echo

info "Unlocking user..."
TMP=$(mktemp)

awk -F: -v u="$USERNAME" '
BEGIN{OFS=":"}
{
    if($1=="!"u){
        $1=u
    }
    print
}
' "$PASSWD_FILE" > "$TMP"

cat "$TMP" > "$PASSWD_FILE"

rm -f "$TMP"

chmod 600 "$PASSWD_FILE"

echo

ok "User unlocked successfully."

echo
echo "=============================================="
echo "Username : $USERNAME"
echo "Status   : Active"
echo "=============================================="
echo

pause

exit 0
