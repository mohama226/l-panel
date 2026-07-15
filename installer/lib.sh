#!/bin/bash

set -e

PROJECT_DIR="/opt/l-panel"

install_dependencies() {

    apt-get update

    apt-get install -y \
        curl \
        unzip \
        rsync \
        python3 \
        python3-pip \
        python3-venv

}

create_venv() {

    if [ ! -d "$PROJECT_DIR/venv" ]; then
        python3 -m venv "$PROJECT_DIR/venv"
    fi

}

install_python() {

    "$PROJECT_DIR/venv/bin/pip" install --upgrade pip

    "$PROJECT_DIR/venv/bin/pip" install \
        -r "$PROJECT_DIR/requirements.txt"

}

fix_permissions() {

    find "$PROJECT_DIR" -type f -name "*.sh" -exec chmod +x {} \;

    chmod +x "$PROJECT_DIR/scripts/l-panel"

}

install_systemd() {

    cp -f \
        "$PROJECT_DIR/systemd/system/l-panel.service" \
        /etc/systemd/system/

    systemctl daemon-reload

    systemctl enable l-panel

}

create_symlink() {

    ln -sf \
        "$PROJECT_DIR/scripts/l-panel" \
        /usr/local/bin/l-panel

}

restart_services() {

    systemctl restart l-panel

}
