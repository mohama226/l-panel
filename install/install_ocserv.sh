#!/bin/bash

set -e


echo "================================="
echo " Installing ocserv 1.5"
echo "================================="


# Update
apt update


# Dependencies
apt install -y \
wget \
curl \
gnutls-bin \
libgnutls30 \
libwrap0 \
libnl-route-3-200 \
libseccomp2 \
ocserv


echo "[+] ocserv installed"


# Stop old service
systemctl stop ocserv || true


# Backup old config
if [ -f /etc/ocserv/ocserv.conf ]; then

    cp /etc/ocserv/ocserv.conf \
    /etc/ocserv/ocserv.conf.backup

fi


# Create directory

mkdir -p /etc/ocserv


# Copy lak-panel config

cp "$(dirname "$0")/configs/ocserv.conf" \
/etc/ocserv/ocserv.conf


echo "[+] ocserv.conf installed"



# Create passwd file

touch /etc/ocserv/ocpasswd

chmod 600 /etc/ocserv/ocpasswd


echo "[+] ocpasswd ready"



# Enable service

systemctl daemon-reload

systemctl enable ocserv


systemctl restart ocserv



echo ""
echo "================================="
echo " ocserv installed successfully"
echo "================================="


systemctl status ocserv --no-pager
