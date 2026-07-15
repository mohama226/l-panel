#!/bin/bash

set -e

TMP="/tmp/l-panel-update"

rm -rf "$TMP"

mkdir -p "$TMP"

echo "Downloading latest release..."

curl -L \
https://github.com/mohama226/l-panel/archive/refs/heads/main.zip \
-o "$TMP/l-panel.zip"

unzip -oq \
"$TMP/l-panel.zip" \
-d "$TMP"

echo "Updating files..."

rsync -a --delete \
"$TMP/l-panel-main/" \
/opt/l-panel/

bash /opt/l-panel/installer/post_install.sh

echo
echo "Update completed successfully."
