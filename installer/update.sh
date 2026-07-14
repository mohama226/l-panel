#!/bin/bash

set -e

echo "Updating L-Panel..."

cd /tmp

curl -L -o l-panel.zip \
https://github.com/mohama226/l-panel/archive/refs/heads/main.zip

unzip -o l-panel.zip

rm -rf /opt/l-panel-new

mv l-panel-main /opt/l-panel-new

rm -rf /opt/l-panel

mv /opt/l-panel-new /opt/l-panel

chmod +x /opt/l-panel/installer/*.sh
chmod +x /opt/l-panel/scripts/*

systemctl daemon-reload

echo "Update completed"
