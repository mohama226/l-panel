#!/bin/bash

set -e


echo "=============================="
echo " Installing OCServ 1.5.0"
echo "=============================="


BASE="/opt/l-panel"
OCVER="1.5.0"


apt update

apt install -y \
git \
wget \
build-essential \
pkg-config \
libgnutls28-dev \
libreadline-dev \
libnl-route-3-dev \
libseccomp-dev \
liblz4-dev \
libprotobuf-c-dev \
protobuf-c-compiler \
libpcl1-dev \
libhttp-parser-dev \
autoconf \
automake \
libtool


mkdir -p /usr/local/src


cd /usr/local/src


if [ ! -f ocserv-${OCVER}.tar.xz ]; then

wget \
https://github.com/openconnect/ocserv/releases/download/${OCVER}/ocserv-${OCVER}.tar.xz

fi


tar xf ocserv-${OCVER}.tar.xz


cd ocserv-${OCVER}


./configure \
--prefix=/usr \
--sysconfdir=/etc


make -j$(nproc)

make install



mkdir -p /etc/ocserv


cp $BASE/installer/files/ocserv/ocserv.conf \
/etc/ocserv/ocserv.conf



cp $BASE/installer/files/ocserv/ocserv.conf \
/etc/ocserv/ocserv.conf.backup



echo "Creating SSL certificate"


openssl req \
-x509 \
-newkey rsa:4096 \
-keyout /etc/ocserv/server-key.pem \
-out /etc/ocserv/server-cert.pem \
-days 3650 \
-nodes \
-subj "/CN=L-PANEL VPN"


touch /etc/ocserv/ocpasswd


systemctl daemon-reload


echo "OCServ installed"


systemctl enable ocserv || true


systemctl restart ocserv || true


echo "DONE"
