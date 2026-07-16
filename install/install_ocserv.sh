#!/bin/bash
set -e

echo "Installing ocserv 1.5.0..."

dnf install -y epel-release
dnf install -y ocserv

systemctl enable ocserv
systemctl start ocserv

echo "Ocserv installed."
