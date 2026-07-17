#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/version.sh"


title

echo
echo "=============================="
echo "       SERVICES STATUS"
echo "=============================="
echo


systemctl --type=service --state=running | grep -E "ocserv|l-panel|nginx|httpd"


pause
