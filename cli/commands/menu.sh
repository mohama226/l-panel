#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

while true
do

clear

title

echo
echo "=============================================="
echo "              USER MANAGER"
echo "=============================================="
echo

echo "1) Create User"

echo "2) Delete User"

echo "3) Change Password"

echo "4) Lock User"

echo "5) Unlock User"

echo "6) Online Users"

echo "7) Disconnect User"

echo "0) Back"

echo

read -rp "Select option: " ACTION

case "$ACTION" in

1)

bash "$CLI_DIR/commands/user-add.sh"

;;

2)

bash "$CLI_DIR/commands/user-delete.sh"

;;

3)

bash "$CLI_DIR/commands/user-password.sh"

;;

4)

bash "$CLI_DIR/commands/user-lock.sh"

;;

5)

bash "$CLI_DIR/commands/user-unlock.sh"

;;

6)

bash "$CLI_DIR/commands/user-online.sh"

;;

7)

bash "$CLI_DIR/commands/user-disconnect.sh"

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
