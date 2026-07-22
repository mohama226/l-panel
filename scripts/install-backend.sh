#!/usr/bin/env bash

set -Eeuo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

BACKEND_DIR="$BASE_DIR/backend"
VENV_DIR="$BACKEND_DIR/venv"

echo "=================================="
echo " Installing L-Panel Backend"
echo "=================================="


if [ ! -d "$BACKEND_DIR" ]; then

    echo "Backend directory not found:"
    echo "$BACKEND_DIR"

    exit 1

fi


if [ ! -d "$VENV_DIR" ]; then

    echo "Creating Python virtual environment..."

    python3 -m venv "$VENV_DIR"

fi


source "$VENV_DIR/bin/activate"


echo
echo "Updating pip..."

pip install --upgrade pip setuptools wheel



if [ -f "$BACKEND_DIR/requirements.txt" ]; then

    echo
    echo "Installing backend requirements..."

    pip install -r "$BACKEND_DIR/requirements.txt"

else

    echo
    echo "requirements.txt not found."

    echo "Creating basic requirements file..."

cat > "$BACKEND_DIR/requirements.txt" <<EOF
flask
flask-cors
gunicorn
psycopg2-binary
sqlalchemy
flask-sqlalchemy
redis
python-jose
passlib
EOF


    pip install -r "$BACKEND_DIR/requirements.txt"

fi



echo
echo "Checking backend files..."


if [ ! -f "$BACKEND_DIR/main.py" ]; then

    echo "main.py not found."

    exit 1

fi



echo
echo "=================================="
echo " Backend installation completed"
echo "=================================="


echo

echo "Backend:"
echo "$BACKEND_DIR"

echo

echo "Python:"
python --version
