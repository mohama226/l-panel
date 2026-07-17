#!/usr/bin/env bash

set -Eeuo pipefail


clear

title


echo
echo "=============================="
echo " OCSERV STATUS"
echo "=============================="
echo


if systemctl status ocserv --no-pager >/dev/null 2>&1
then

    systemctl status ocserv --no-pager -l

else

    fail "Ocserv service not found"

fi


echo

pause
