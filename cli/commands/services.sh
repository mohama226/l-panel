#!/usr/bin/env bash

set -Eeuo pipefail


clear

title


echo
echo "=============================="
echo " L-PANEL SERVICES"
echo "=============================="
echo


SERVICES=(
    "ocserv"
    "firewalld"
    "fail2ban"
    "nginx"
    "sshd"
)


for SERVICE in "${SERVICES[@]}"
do

    if systemctl list-unit-files | grep -q "^${SERVICE}.service"
    then

        STATUS=$(systemctl is-active "$SERVICE" || true)


        if [[ "$STATUS" == "active" ]]
        then
            ok "$SERVICE : RUNNING"
        else
            warn "$SERVICE : STOPPED"
        fi

    else

        info "$SERVICE : NOT INSTALLED"

    fi

done


echo

pause
