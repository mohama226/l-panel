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
echo "              LOCK USER"
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

if ! grep -q "^${USERNAME}:" "$PASSWD_FILE"; then

    fail "User not found."

    pause
    exit 1

fi

LINE=$(grep "^${USERNAME}:" "$PASSWD_FILE")

if [[ "$LINE" == \!* ]]; then

    warn "User already locked."

    pause
    exit 0

fi

echo
read -rp "Lock this user? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" ]]; then

    echo
    warn "Cancelled."

    pause
    exit 0

fi

echo

info "Locking user..."
TMP=$(mktemp)

awk -F: -v u="$USERNAME" '
BEGIN{OFS=":"}
{
    if($1==u){
        print "!"$1,$2
    }else{
        print
    }
}
' "$PASSWD_FILE" > "$TMP"

cat "$TMP" > "$PASSWD_FILE"

rm -f "$TMP"

chmod 600 "$PASSWD_FILE"

if command -v occtl >/dev/null 2>&1; then

    SID=$(occtl show users 2>/dev/null | awk -v u="$USERNAME" '$0 ~ u {print $1; exit}')

    if [[ -n "${SID:-}" ]]; then

        occtl disconnect id "$SID" >/dev/null 2>&1 || true

    fi

fi

echo

ok "User locked successfully."

echo
echo "=============================================="
echo "Username : $USERNAME"
echo "Status   : Locked"
echo "=============================================="
echo

pause

exit 0
