#!/usr/bin/env bash

set -e


cd /opt/l-panel/frontend


if ! command -v npm >/dev/null; then

    echo "Installing NodeJS"

    dnf install -y nodejs npm

fi


npm install

npm run build


echo "Frontend build completed"
