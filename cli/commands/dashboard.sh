#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"

title

INFO_FILE="/etc/l-panel/ocserv.info"

VERSION="-"
PORT="-"

# 🔥 اصلاح شده طبق درخواست تو
if [[ -f "$INFO_FILE" ]]; then
    source "$INFO_FILE" 2>/dev/null || true
fi

while true
do

clear

title

echo
echo "=============================================="
echo "             SYSTEM DASHBOARD"
echo "=============================================="
echo

DATE_NOW="$(date '+%Y-%m-%d %H:%M:%S')"
HOST="$(hostname)"
KERNEL="$(uname -r)"
UPTIME="$(uptime -p)"
LOAD="$(cut -d' ' -f1-3 /proc/loadavg)"

echo "Date      : $DATE_NOW"
echo "Hostname  : $HOST"
echo "Kernel    : $KERNEL"
echo "Uptime    : $UPTIME"
echo "Load Avg  : $LOAD"

echo
#############################################
# CPU
#############################################

CPU_USAGE=$(top -bn1 | awk '/Cpu/ {print 100-$8}')

echo "CPU"
echo "------------------------------"
printf "Usage : %.1f%%\n" "$CPU_USAGE"

CORES=$(nproc)
echo "Cores : $CORES"
echo

#############################################
# MEMORY
#############################################

read MEM_TOTAL MEM_USED <<<$(free -m | awk '/Mem:/ {print $2" "$3}')
MEM_PERCENT=$((MEM_USED*100/MEM_TOTAL))

echo "Memory"
echo "------------------------------"
echo "Used  : ${MEM_USED} MB"
echo "Total : ${MEM_TOTAL} MB"
echo "Usage : ${MEM_PERCENT}%"
echo

#############################################
# DISK
#############################################

DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_PERCENT=$(df -h / | awk 'NR==2 {print $5}')

echo "Disk"
echo "------------------------------"
echo "Used  : $DISK_USED"
echo "Total : $DISK_TOTAL"
echo "Usage : $DISK_PERCENT"
echo

#############################################
# NETWORK
#############################################

RX=$(cat /proc/net/dev | awk -F'[: ]+' '/:/ && $1!="lo" {rx+=$3} END {print rx}')
TX=$(cat /proc/net/dev | awk -F'[: ]+' '/:/ && $1!="lo" {tx+=$11} END {print tx}')

echo "Network"
echo "------------------------------"
echo "Received : $((RX/1024/1024)) MB"
echo "Sent     : $((TX/1024/1024)) MB"
echo

#############################################
# OCSERV
#############################################

STATUS="Stopped"

if systemctl is-active ocserv >/dev/null 2>&1; then
    STATUS="Running"
fi

ONLINE=0

if command -v occtl >/dev/null 2>&1; then
    ONLINE=$(occtl show users 2>/dev/null | tail -n +2 | wc -l)
fi

TOTAL_USERS=0

if [[ -f /etc/ocserv/ocpasswd ]]; then
    TOTAL_USERS=$(grep -vc '^$' /etc/ocserv/ocpasswd)
fi

echo "Ocserv"
echo "------------------------------"
echo "Version : ${VERSION:-Unknown}"
echo "Port    : ${PORT:-Unknown}"
echo "Status  : $STATUS"
echo "Users   : $TOTAL_USERS"
echo "Online  : $ONLINE"
echo

#############################################
# SYSTEM HEALTH
#############################################

echo "Health"
echo "------------------------------"

if [[ "$STATUS" == "Running" ]]; then
    echo "Ocserv      : OK"
else
    echo "Ocserv      : DOWN"
fi

ROOT_USE=$(df / | awk 'NR==2 {gsub("%","");print $5}')

if [[ "$ROOT_USE" -gt 90 ]]; then
    echo "Disk Space  : WARNING"
else
    echo "Disk Space  : OK"
fi

if [[ "$MEM_PERCENT" -gt 90 ]]; then
    echo "Memory      : WARNING"
else
    echo "Memory      : OK"
fi

echo
echo "=============================================="
echo
echo "R = Refresh"
echo "Q = Back"
echo

read -rn1 KEY

case "$KEY" in
R|r) continue ;;
Q|q) break ;;
*) break ;;
esac

done

exit 0
