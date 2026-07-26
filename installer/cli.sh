#!/bin/bash

install_cli() {

info "Installing CLI..."

install -m755 scripts/l-panel /usr/local/bin/l-panel

success "CLI Installed."

}
