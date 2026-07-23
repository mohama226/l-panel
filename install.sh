#!/bin/bash

set -e

APP_DIR="/opt/l-panel"

echo "======================"
echo " L-PANEL INSTALL"
echo "======================"


if command -v apt >/dev/null 2>&1
then

    echo "Ubuntu/Debian detected"

    apt update

    apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    git


elif command -v dnf >/dev/null 2>&1
then

    echo "AlmaLinux/RHEL detected"

    dnf install -y \
    python3 \
    python3-pip \
    python3-virtualenv \
    git


elif command -v yum >/dev/null 2>&1
then

    echo "CentOS detected"

    yum install -y \
    python3 \
    python3-pip \
    python3-virtualenv \
    git


else

    echo "Unsupported OS"

    exit 1

fi
