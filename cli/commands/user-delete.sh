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
echo "              DELETE USER"
echo "=============================================="
echo

if ! command -v ocpasswd >/dev/null 2>&1; then

    fail "ocpasswd command not found."

    pause

    exit 1

fi

if [[ ! -f "$PASSWD_FILE" ]]; then

    fail "Password database not found."

    pause

    exit 1

fi

read -rp "Username : " USERNAME

USERNAME=$(echo "$USERNAME" | xargs)

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

echo
echo "WARNING!"
echo "This user will be permanently deleted."
echo

read -rp "Continue? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" ]]; then

    warn "Operation cancelled."

    pause

    exit 0

fi

echo

info "Deleting user..."
# Disconnect user if online
if command -v occtl >/dev/null 2>&1; then

    ID=$(occtl show users 2>/dev/null | awk -v u="$USERNAME" '$0 ~ u {print $1; exit}')

    if [[ -n "${ID:-}" ]]; then
        occtl disconnect id "$ID" >/dev/null 2>&1 || true
    fi

fi

# Delete user
ocpasswd -d "$PASSWD_FILE" "$USERNAME"

if [[ $? -ne 0 ]]; then

    fail "Failed to delete user."

    pause

    exit 1

fi

echo

ok "User deleted successfully."

echo
echo "=============================================="
echo "Deleted User"
echo "=============================================="
echo

echo "Username : $USERNAME"

echo

pause

exit 0
