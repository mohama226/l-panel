#!/usr/bin/env bash


source "$(dirname "$0")/variables.sh"

source "$(dirname "$0")/functions.sh"



blue "Installing Python Environment"



cd "$INSTALL_DIR/backend"



python3 -m venv venv



source venv/bin/activate



pip install --upgrade pip



if [ -f requirements.txt ]

then

pip install -r requirements.txt

fi



green "Python ready."
