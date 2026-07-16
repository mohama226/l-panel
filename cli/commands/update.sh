#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_DIR="$(dirname "$SCRIPT_DIR")"

source "$CLI_DIR/../lib/colors.sh"
source "$CLI_DIR/../lib/common.sh"

require_root


TMP_DIR=$(mktemp -d)

cleanup(){
    rm -rf "$TMP_DIR"
}

trap cleanup EXIT


update(){

    title

    info "Checking GitHub updates..."

    cd "$TMP_DIR"


    curl -fsSL \
    https://github.com/mohama226/l-panel/archive/refs/heads/main.zip \
    -o l-panel.zip


    unzip -q l-panel.zip


    NEW_DIR=$(find . -maxdepth 1 -type d -name "l-panel-*")


    if [[ -z "$NEW_DIR" ]]; then

        fail "Download failed."

        exit 1

    fi


    info "Updating files..."


    cp -a "$NEW_DIR/." /opt/l-panel/


    date "+%Y-%m-%d %H:%M:%S" \
    > /opt/l-panel/.last_update


    chmod +x /opt/l-panel/cli/l-panel

    chmod +x /opt/l-panel/cli/commands/*.sh


    ok "Update completed."

    echo

    echo "Updated:"
    cat /opt/l-panel/.last_update


    pause

}


update
