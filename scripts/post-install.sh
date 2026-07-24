#!/bin/bash

echo "Configuring L-PANEL OCServ..."

mkdir -p /etc/ocserv

touch /etc/ocserv/ocpasswd

chown root:root /etc/ocserv
chmod 755 /etc/ocserv

chown root:root /etc/ocserv/ocpasswd
chmod 600 /etc/ocserv/ocpasswd


chmod +x /var/www/html/l-panel/scripts/*.sh


cat >/etc/sudoers.d/l-panel-ocserv <<EOF
apache ALL=(root) NOPASSWD: /var/www/html/l-panel/scripts/ocserv-manager.sh
EOF


chmod 440 /etc/sudoers.d/l-panel-ocserv


echo "L-PANEL OCServ permissions configured"
