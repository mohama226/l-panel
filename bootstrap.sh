#!/usr/bin/env bash

set -Eeuo pipefail


#############################################
# Variables
#############################################

REPO="mohama226/l-panel"

BRANCH="main"

ZIP_URL="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.zip"


TMP_DIR=$(mktemp -d)



#############################################
# Cleanup
#############################################

cleanup(){

    rm -rf "$TMP_DIR"

}


trap cleanup EXIT



#############################################
# Root Check
#############################################

if [[ $EUID -ne 0 ]]; then

    echo "Please run as root."

    exit 1

fi



echo

echo "==================================="

echo "       L-PANEL Bootstrap"

echo "==================================="

echo



#############################################
# Package Manager
#############################################

if command -v dnf >/dev/null 2>&1; then

    PKG="dnf"


elif command -v yum >/dev/null 2>&1; then

    PKG="yum"


else

    echo "Unsupported Linux."

    exit 1

fi



#############################################
# Dependencies
#############################################

install_package(){


    COMMAND=$1

    PACKAGE=$2



    if ! command -v "$COMMAND" >/dev/null 2>&1; then


        echo "Installing $PACKAGE ..."


        $PKG install -y "$PACKAGE"


    fi


}



install_package curl curl

install_package unzip unzip

install_package zip zip

install_package wget wget



#############################################
# Download
#############################################

echo

echo "Downloading L-Panel..."



curl -L "$ZIP_URL" \
-o "$TMP_DIR/l-panel.zip"



#############################################
# Extract
#############################################

echo

echo "Extracting..."



unzip -q \
"$TMP_DIR/l-panel.zip" \
-d "$TMP_DIR"



#############################################
# Locate Project
#############################################

PROJECT_DIR=$(find "$TMP_DIR" -maxdepth 1 -type d -name "l-panel-*" | head -n1)



if [[ -z "$PROJECT_DIR" ]]; then

    echo "Project directory not found."

    exit 1

fi



#############################################
# Install
#############################################

echo

echo "Running installer..."



cd "$PROJECT_DIR"



chmod +x installer/install.sh



bash installer/install.sh



echo

echo "==================================="

echo " Installation Finished"

echo "==================================="

echo

echo "Run command:"

echo

echo "l-panel"

echo
