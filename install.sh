#!/bin/bash

set -e

REPO="https://github.com/mohama226/l-panel.git"
BASE_DIR="/tmp/lpanel-installer"


echo "
=================================
       L-PANEL INSTALLER
          Laravel v1.0
=================================
"


detect_os(){

    if [ -f /etc/almalinux-release ]; then

        OS="almalinux"

    elif grep -qi ubuntu /etc/os-release; then

        OS="ubuntu"

    else

        echo "[ERROR] Unsupported OS"
        exit 1

    fi


    echo "[OK] OS detected: $OS"

}



install_base(){


    if [ "$OS" = "almalinux" ]; then


        dnf install -y git curl wget unzip


    else


        apt update

        apt install -y git curl wget unzip


    fi


    echo "[OK] Base packages installed"

}



download(){


    rm -rf $BASE_DIR

    mkdir -p $BASE_DIR


    git clone $REPO $BASE_DIR


}



run_installer(){


    cd $BASE_DIR


    chmod +x installer/*.sh


    source installer/main.sh


}



detect_os

install_base

download

run_installer
