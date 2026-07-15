#!/bin/bash

set -e

TMP="/tmp/l-panel-update"

rm -rf "$TMP"

mkdir -p "$TMP"

echo "Downloading..."

curl -L \
https://github.com/mohama226/l-panel/archive/refs/heads/main.zip \
-o "$TMP/panel.zip"

unzip -oq "$TMP/panel.zip" -d "$TMP"

cp -rf \
"$TMP"/l-panel-main/* \
/opt/l-panel/

bash /opt/l-panel/installer/post_install.sh

echo
echo "Update completed."
