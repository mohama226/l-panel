#!/bin/bash

#######################################
# LAK PANEL GLOBAL CONFIG
#######################################

PROJECT_NAME="LAK Panel"

BASE_DIR="/opt/lak-panel"

BACKEND_DIR="$BASE_DIR/backend"

APP_DIR="$BACKEND_DIR/app"

VENV_DIR="$BACKEND_DIR/venv"

ENV_FILE="$BACKEND_DIR/.env"

SERVICE_FILE="/etc/systemd/system/lak-panel.service"

BACKUP_DIR="$BASE_DIR/backups"

OCSERV_DIR="$BASE_DIR/ocserv"

SCRIPT_DIR="$BASE_DIR/scripts"

INSTALL_DIR="$BASE_DIR/installer"


#######################################
# DEFAULT SETTINGS
#######################################

DEFAULT_PORT="2096"

DEFAULT_DB="$BACKEND_DIR/database.db"


#######################################
# DISPLAY
#######################################

show_paths(){

echo ""
echo "======================================"
echo "       LAK PANEL PATH CONFIG"
echo "======================================"

echo "Project:"
echo "$BASE_DIR"

echo ""

echo "Backend:"
echo "$BACKEND_DIR"

echo ""

echo "Virtual ENV:"
echo "$VENV_DIR"

echo ""

echo "Database:"
echo "$DEFAULT_DB"

echo ""

echo "Backup:"
echo "$BACKUP_DIR"

echo ""

echo "OCServ:"
echo "$OCSERV_DIR"

echo ""

echo "Systemd:"
echo "$SERVICE_FILE"

echo "======================================"
echo ""

}
