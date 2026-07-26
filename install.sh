#!/bin/bash

set -e


REPO="https://github.com/mohama226/l-panel.git"

INSTALL_DIR="/opt/l-panel"


echo "Installing L-Panel"


if [ -d "$INSTALL_DIR/.git" ]; then

echo "Updating existing installation"

cd $INSTALL_DIR

git pull

else


rm -rf $INSTALL_DIR

git clone $REPO $INSTALL_DIR


fi


cd $INSTALL_DIR


chmod +x installer/*.sh


bash installer/main.sh
