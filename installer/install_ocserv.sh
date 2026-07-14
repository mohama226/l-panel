#!/bin/bash

set -e

BASE="/opt/l-panel"
VERSION="1.5.0"

echo "=============================="
echo " L-PANEL OCServ Installer"
echo " OCServ Version $VERSION"
echo "=============================="

apt update

apt install -y \
build-essential \
meson \
ninja-build \
pkg-config \
libgnutls28-dev \
libreadline-dev \
libnl-route-3-dev \
libseccomp-dev \
liblz4-dev \
libprotobuf-c-dev \
protobuf-c-compiler \
libpam0g-dev \
libwrap0-dev \
autoconf \
automake \
libtool \
wget \
tar \
openssl

mkdir -p /usr/local/src

cd /usr/local/src

rm -rf ocserv-$VERSION
rm -f ocserv-$VERSION.tar.xz

echo "Downloading OCServ..."

wget https://www.infradead.org/ocserv/download/ocserv-$VERSION.tar.xz

tar xf ocserv-$VERSION.tar.xz

cd ocserv-$VERSION

echo "Building OCServ..."

meson setup build \
--prefix=/usr \
--sysconfdir=/etc

ninja -C build

ninja -C build install

echo "Generating certificate..."

openssl req \
-x509 \
-newkey rsa:4096 \
-keyout /etc/ocserv/server-key.pem \
-out /etc/ocserv/server-cert.pem \
-days 3650 \
-nodes \
-subj "/CN=L-PANEL"

# ==================== بخش اضافه شده ====================
echo "Creating config and password file..."

mkdir -p /etc/ocserv

cp $BASE/installer/configs/ocserv.conf /etc/ocserv/ocserv.conf

touch /etc/ocserv/ocpasswd
chmod 600 /etc/ocserv/ocpasswd
# =======================================================

echo "Creating service..."

cat >/etc/systemd/system/ocserv.service <<EOF

[Unit]
Description=OCServ VPN Server
After=network.target

[Service]
ExecStart=/usr/sbin/ocserv -f -c /etc/ocserv/ocserv.conf
Restart=always

[Install]
WantedBy=multi-user.target

EOF

systemctl daemon-reload
systemctl enable ocserv

echo ""
echo "OCServ installed successfully"
echo ""

ocserv -v
