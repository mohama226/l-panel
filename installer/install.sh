#!/bin/bash

apt update

apt install -y python3 python3-pip python3-venv

python3 -m venv venv

source venv/bin/activate

pip install -r requirements.txt

python3 run.py
