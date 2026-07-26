#!/bin/bash

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"


banner(){

echo -e "
=================================
       L-PANEL INSTALLER
          Laravel v1.0
=================================
"

}


success(){

echo -e "${GREEN}[OK] $1${RESET}"

}


error(){

echo -e "${RED}[ERROR] $1${RESET}"

}


warning(){

echo -e "${YELLOW}[WARN] $1${RESET}"

}
