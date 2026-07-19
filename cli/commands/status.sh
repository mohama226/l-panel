#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

INFO_FILE="/etc/l-panel/ocserv.info"

title

echo
echo "=============================================="
echo "             OCSERV STATUS"
echo "=============================================="
echo

VERSION="-"
PORT="-"

# 🔥 اصلاح شده طبق درخواست تو
if [[ -f "$INFO_FILE" ]]; then
    source "$INFO_FILE" 2>/dev/null || true
fi

VERSION="${VERSION:-Unknown}"
PORT="${PORT:-Unknown}"

echo "Version : $VERSION"
echo "Port    : $PORT"
echo

STATUS="Stopped"

if systemctl is-active ocserv >/dev/null 2>&1; then
    STATUS="Running"
fi

PID="-"

if systemctl is-active ocserv >/dev/null 2>&1; then
    PID=$(pidof ocserv || echo "-")
fi

UPTIME="-"

if [[ "$PID" != "-" ]]; then
    UPTIME=$(ps -o etime= -p "$PID" | xargs)
fi

echo "Service : $STATUS"
echo "PID     : $PID"
echo "Uptime  : $UPTIME"
echo

CPU="-"
RAM="-"

if [[ "$PID" != "-" ]]; then
    CPU=$(ps -p "$PID" -o %cpu= | xargs)
    RAM=$(ps -p "$PID" -o %mem= | xargs)
fi

echo "CPU Usage : ${CPU}%"
echo "RAM Usage : ${RAM}%"
echo

ONLINE=0

if command -v occtl >/dev/null 2>&1; then
    ONLINE=$(occtl show users 2>/dev/null | tail -n +2 | wc -l)
fi

TOTAL_USERS=0

if [[ -f /etc/ocserv/ocpasswd ]]; then
    TOTAL_USERS=$(grep -vc '^$' /etc/ocserv/ocpasswd)
fi

echo "Users"
echo "----------------------------"
echo "Registered : $TOTAL_USERS"
echo "Online     : $ONLINE"
echo

echo "System"
echo "----------------------------"
echo "Hostname : $(hostname)"
echo "Kernel   : $(uname -r)"
echo "OS       : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '\"')"
echo

systemctl --no-pager --full status ocserv | head -20
echo

pause
exit 0
