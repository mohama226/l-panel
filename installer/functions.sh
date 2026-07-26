#!/bin/bash


GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"


ok(){

echo -e "${GREEN}[OK]${NC} $1"

}


error(){

echo -e "${RED}[ERROR]${NC} $1"

exit 1

}


banner(){

clear

echo "
================================

          L-PANEL INSTALLER

              v2.0

================================
"

}


success(){

echo "

================================

L-Panel Installed Successfully


URL:

http://SERVER-IP:${PANEL_PORT}


Command:

l-panel


================================

"

}
