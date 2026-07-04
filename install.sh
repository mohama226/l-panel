#!/bin/bash

set -e

echo "Updating packages..."
apt update

echo "Installing dependencies..."
apt install -y python3 python3-pip python3-venv git nginx

echo "Creating virtual environment..."
cd backend

python3 -m venv venv

source venv/bin/activate

pip install --upgrade pip

pip install -r requirements.txt

echo "Installation completed."
