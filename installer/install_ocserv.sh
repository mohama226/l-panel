#!/bin/bash

source /opt/l-panel/installer/core.sh


echo "Installing Ocserv 1.5.0"


apt update


apt install -y \
git \
build-essential \
pkg-config \
gnutls-bin \
libgnutls28-dev \
libnl-route-3-dev \
libnl-3-dev \
libseccomp-dev \
libreadline-dev \
libpam0g-dev \
libwrap0-dev \
liblz4-dev \
libev-dev \
autoconf \
automake \
libtool \
gettext \
wget


cd /usr/local/src


rm -rf ocserv


git clone https://github.com/openconnect/ocserv.git


cd ocserv


git checkout v1.5.0


./autogen.sh


./configure \
--prefix=/usr \
--sysconfdir=/etc


make -j$(nproc)


make install



mkdir -p /etc/ocserv


cp /opt/l-panel/installer/configs/ocserv.conf \
/etc/ocserv/ocserv.conf



if [ ! -f /etc/ocserv/server-cert.pem ]
then

echo "Generating certificate"


certtool --generate-privkey \
--outfile /etc/ocserv/server-key.pem


cat >/tmp/ocserv-cert.cfg <<EOF
organization = L-PANEL
cn = VPN Server
expiration_days = 3650
EOF


certtool \
--generate-certificate \
--load-privkey /etc/ocserv/server-key.pem \
--outfile /etc/ocserv/server-cert.pem \
--template /tmp/ocserv-cert.cfg

fi



echo "Creating password file"

touch /etc/ocserv/ocpasswd


echo "Creating systemd service"


cat >/etc/systemd/system/ocserv.service <<EOF
[Unit]
Description=Ocserv VPN Server
After=network.target


[Service]
ExecStart=/usr/sbin/ocserv -c /etc/ocserv/ocserv.conf
Restart=always


[Install]
WantedBy=multi-user.target
EOF



systemctl daemon-reload


systemctl enable ocserv


systemctl restart ocserv



echo
echo "================================"
echo " Ocserv 1.5.0 Installed"
echo "================================"

systemctl status ocserv --no-pager
