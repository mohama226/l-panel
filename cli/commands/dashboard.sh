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

[[ -f "$INFO_FILE" ]] && source "$INFO_FILE"

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
