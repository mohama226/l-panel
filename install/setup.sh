#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/variables.sh"
source "$SCRIPT_DIR/functions.sh"
source "$SCRIPT_DIR/logo.sh"
check_root
wait_for_apt
create_directories
bash "$SCRIPT_DIR/postgres.sh"
bash "$SCRIPT_DIR/python.sh"
bash "$SCRIPT_DIR/service.sh"
bash "$SCRIPT_DIR/nginx.sh"
bash "$SCRIPT_DIR/firewall.sh"
bash "$SCRIPT_DIR/ssl.sh"
bash "$SCRIPT_DIR/ocserv.sh"

chmod +x /opt/l-panel/cli/*
ln -sf /opt/l-panel/cli/l-panel /usr/local/bin/l-panel

green "Installation Completed."
