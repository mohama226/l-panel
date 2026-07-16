#!/bin/bash
set -e

echo "Installing l-panel..."

dnf install -y python3 python3-pip postgresql-server postgresql-contrib
postgresql-setup --initdb
systemctl enable postgresql
systemctl start postgresql

sudo -u postgres psql -c "CREATE USER lpanel WITH PASSWORD '1234';"
sudo -u postgres psql -c "CREATE DATABASE lpanel OWNER lpanel;"

pip3 install -r requirements.txt

echo "Installation complete."
