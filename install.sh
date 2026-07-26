#!/bin/bash

set -e


REPO="https://github.com/mohama226/l-panel.git"

TMP="/tmp/l-panel-install"


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

    echo "Unsupported OS"
    exit 1

fi


echo "[OK] OS: $OS"

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


rm -rf $TMP


git clone $REPO $TMP


cd $TMP


}



run(){

chmod +x installer/*.sh


source installer/main.sh


}



detect_os

install_base

download

run
