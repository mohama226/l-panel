#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

PASSWD_FILE="/etc/ocserv/ocpasswd"

title

while true
do

clear
title

echo
echo "=============================================="
echo "            USER MANAGER"
echo "=============================================="
echo

echo "1) Add User"
echo "2) Edit Password"
echo "3) Delete User"
echo "4) Lock User"
echo "5) Unlock User"
echo "6) List Users"
echo "7) Search User"
echo "8) User Information"
echo "9) Back"
echo

read -rp "Select option: " OPTION

case "$OPTION" in

1)

bash "$SCRIPT_DIR/user-add.sh"

;;

2)

bash "$SCRIPT_DIR/user-password.sh"

;;

3)

bash "$SCRIPT_DIR/user-delete.sh"

;;

4)

bash "$SCRIPT_DIR/user-lock.sh"

;;

5)

bash "$SCRIPT_DIR/user-unlock.sh"

;;

6)

clear
title

echo
echo "=============================================="
echo "               USERS"
echo "=============================================="
echo

if [[ ! -f "$PASSWD_FILE" ]]; then

    fail "ocpasswd file not found."

    pause

    continue

fi

awk -F: '{print NR") "$1}' "$PASSWD_FILE"

echo

echo "Total Users: $(wc -l < "$PASSWD_FILE")"

echo

pause

;;

7)

clear
title

echo
read -rp "Username: " USERNAME

echo

if grep -q "^${USERNAME}:" "$PASSWD_FILE"; then

    ok "User found."

    grep "^${USERNAME}:" "$PASSWD_FILE" | cut -d: -f1

else

    fail "User not found."

fi

echo

pause

;;
8)

clear
title

echo
read -rp "Username: " USERNAME

echo

if [[ ! -f "$PASSWD_FILE" ]]; then

    fail "ocpasswd file not found."

    pause

    continue

fi

LINE=$(grep "^${USERNAME}:" "$PASSWD_FILE" || true)

if [[ -z "$LINE" ]]; then

    fail "User not found."

    pause

    continue

fi

echo "=============================================="
echo "User Information"
echo "=============================================="
echo

echo "Username : $USERNAME"

if echo "$LINE" | grep -q '^!'; then
    echo "Status   : Locked"
else
    echo "Status   : Active"
fi

if command -v occtl >/dev/null 2>&1; then

    if occtl show users 2>/dev/null | grep -qw "$USERNAME"; then
        echo "Online   : Yes"
    else
        echo "Online   : No"
    fi

else

    echo "Online   : Unknown"

fi

echo

pause

;;

9)

break

;;

*)

echo

fail "Invalid option."

pause

;;

esac

done

exit 0
