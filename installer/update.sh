#!/bin/bash

echo "Updating L-Panel..."

cd /opt/l-panel

curl -L https://github.com/mohama226/l-panel/archive/refs/heads/main.zip -o /tmp/l-panel.zip

unzip -oq /tmp/l-panel.zip -d /tmp

cp -rf /tmp/l-panel-main/* /opt/l-panel/

systemctl restart l-panel

echo

echo "Update Finished."
