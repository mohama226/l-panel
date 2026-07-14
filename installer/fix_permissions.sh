#!/bin/bash

BASE="/opt/l-panel"

echo "Fixing L-Panel permissions..."

find $BASE/installer -type f -name "*.sh" -exec chmod +x {} \;
find $BASE/scripts -type f -exec chmod +x {} \;

chmod +x /usr/local/bin/l-panel 2>/dev/null || true

echo "Permissions fixed."
