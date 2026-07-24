#!/bin/bash

set -e

echo "=============================="
echo " Installing OCServ 1.5.0 (Correct Build)"
echo "=============================="

if [ -f /etc/os-release ]; then
    source /etc/os-release
fi

echo "Detected: $PRETTY_NAME"

echo "Installing dependencies..."

if command -v dnf >/dev/null
then

    dnf install -y epel-release
    dnf config-manager --set-enabled crb || true

    dnf install -y \
        gcc \
        gcc-c++ \
        make \
        git \
        wget \
        openssl-devel \
        libnl3-devel \
        libseccomp-devel \
        pam-devel \
        readline-devel \
        zlib-devel \
        gnutls-devel \
        autoconf \
        automake \
        libtool \
        pkgconf-pkg-config \
        gettext \
        flex \
        bison \
        texinfo \
        help2man \
        which \
        findutils \
        gperf

    echo "Installing missing libraries"

    dnf install -y \
        protobuf-c \
        protobuf-c-devel \
        protobuf-c-compiler \
        protobuf \
        protobuf-devel || true

    dnf install -y libev libev-devel || true

else
    echo "This installer is for AlmaLinux only."
    exit 1
fi

echo "Preparing source directory..."

rm -rf /usr/local/src/ocserv
mkdir -p /usr/local/src
cd /usr/local/src

echo "Cloning OCServ repository..."
git clone https://gitlab.com/openconnect/ocserv.git ocserv

cd ocserv

git fetch --tags

VERSION="1.5.0"

echo "Installing version: $VERSION"

git checkout "$VERSION"

echo "Running autogen.sh"

chmod +x autogen.sh
./autogen.sh

echo "Running configure"

chmod +x configure

./configure \
    --prefix=/usr \
    --sysconfdir=/etc

echo "Building OCServ"

make -j$(nproc)

echo "Installing OCServ"

make install

echo "OCServ installed"

mkdir -p /etc/ocserv

cp /var/www/html/l-panel/scripts/ocserv.conf /etc/ocserv/ocserv.conf
cp /var/www/html/l-panel/scripts/ocserv.service /etc/systemd/system/ocserv.service

systemctl daemon-reload
systemctl enable ocserv
systemctl restart ocserv

echo ""
echo "=============================="
echo "OCServ $VERSION Installed Successfully"
echo "=============================="
