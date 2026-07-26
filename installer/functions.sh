#!/bin/bash


ROOT_DIR="/opt/l-panel"



banner(){

clear

echo "================================="
echo "       L-PANEL INSTALLER"
echo "================================="

}



ok(){

echo "[OK] $1"

}



error(){

echo "[ERROR] $1"
exit 1

}



info(){

echo "[INFO] $1"

}



warning(){

echo "[WARN] $1"

}



create_env(){

cat > $ROOT_DIR/.env <<EOF

APP_NAME=L-Panel
APP_ENV=production
APP_DEBUG=false

APP_URL=http://127.0.0.1

DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=${DB_NAME}
DB_USERNAME=${DB_USER}
DB_PASSWORD=${DB_PASS}

TIMEZONE=UTC

EOF


ok ".env created"

}
