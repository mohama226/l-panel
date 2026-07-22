#!/usr/bin/env bash

set -Eeuo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

FRONTEND_DIR="$BASE_DIR/frontend"

echo "=================================="
echo " Installing L-Panel Frontend"
echo "=================================="

if ! command -v npm >/dev/null 2>&1; then

    echo "npm not found."

    echo "Please install Node.js first."

    exit 1

fi


if [ -d "$FRONTEND_DIR" ]; then

    echo "Frontend directory exists."

else

    echo "Creating React project..."

    cd "$BASE_DIR"

    npm create vite@latest frontend -- --template react-ts

fi


cd "$FRONTEND_DIR"


echo "Installing frontend packages..."

npm install


echo
echo "Frontend installation completed."

echo "Location:"
echo "$FRONTEND_DIR"
