#!/bin/bash

banner() {

clear

cat << "EOF"

############################################################
#                                                          #
#                    L-PANEL INSTALLER                     #
#                                                          #
#                     Version 2.0.0                        #
#                                                          #
############################################################

EOF

}

check_root() {

if [ "$EUID" -ne 0 ]; then

echo "Please run as root."

exit 1

fi

}

info() {

echo "[INFO] $1"

}

success() {

echo "[ OK ] $1"

}

warning() {

echo "[WARN] $1"

}

error() {

echo "[FAIL] $1"

exit 1

}

finish_install() {

echo

success "Installation Finished."

}
