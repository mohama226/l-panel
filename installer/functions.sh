#!/bin/bash


BASE="/opt/lak-panel"


GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"


title()
{

echo
echo "================================="
echo "$1"
echo "================================="

}



success()
{
echo -e "${GREEN}$1${NC}"
}


error()
{
echo -e "${RED}$1${NC}"
}



check_root()
{

if [ "$EUID" -ne 0 ]
then
echo "Please run as root"
exit 1
fi

}


