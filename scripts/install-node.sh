#!/usr/bin/env bash

set -e

echo "=================================="
echo " Installing Node.js 22 LTS"
echo "=================================="

if command -v node >/dev/null 2>&1; then
    echo "Node.js already installed:"
    node -v
    npm -v
    exit 0
fi

if command -v dnf >/dev/null 2>&1; then

    dnf install -y curl

    curl -fsSL https://rpm.nodesource.com/setup_22.x | bash -

    dnf install -y nodejs

elif command -v apt >/dev/null 2>&1; then

    apt update

    apt install -y curl

    curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

    apt install -y nodejs

else

    echo "Unsupported operating system."

    exit 1

fi

echo
echo "Node Version : $(node -v)"
echo "NPM Version  : $(npm -v)"
echo
echo "Node.js installation completed."
