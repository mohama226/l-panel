#!/bin/bash


echo "Removing L-PANEL"



systemctl stop lpanel-agent 2>/dev/null

systemctl disable lpanel-agent 2>/dev/null



rm -f /etc/systemd/system/lpanel-agent.service

systemctl daemon-reload



rm -f /usr/local/bin/lpanel

rm -f /usr/local/bin/lpanel-agent.php



rm -rf /var/www/html/l-panel



rm -f /etc/httpd/conf.d/lpanel.conf



systemctl restart httpd



echo "L-PANEL removed successfully"
