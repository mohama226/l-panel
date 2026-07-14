#!/bin/bash

read -p "Remove L-Panel ? [y/N] " ans

if [[ "$ans" != "y" ]]; then
    exit
fi

systemctl stop l-panel

systemctl disable l-panel

rm -f /etc/systemd/system/l-panel.service

systemctl daemon-reload

rm -rf /opt/l-panel

rm -f /usr/local/bin/l-panel

echo "Removed."
