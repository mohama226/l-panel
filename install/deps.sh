#!/bin/bash
set -e

echo "[+] Installing required packages for AlmaLinux..."

dnf install -y epel-release
dnf install -y git
dnf install -y python3 python3-pip python3-devel
dnf install -y gcc gcc-c++ make
dnf install -y postgresql postgresql-server postgresql-devel
dnf install -y ocserv
dnf install -y python3-jinja2

pip3 install Jinja2 uvicorn fastapi starlette

echo "[+] All dependencies installed successfully."
