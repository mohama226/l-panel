#!/usr/bin/env bash


source "$(dirname "$0")/variables.sh"


if command -v ufw >/dev/null 2>&1

then

ufw allow 22/tcp

ufw allow 80/tcp

ufw allow ${PANEL_PORT}/tcp

ufw --force enable


fi


echo "Firewall configured."
