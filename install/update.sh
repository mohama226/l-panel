#!/bin/bash
set -e

echo "Updating l-panel..."
git pull
pip3 install -r requirements.txt
echo "Updated."
