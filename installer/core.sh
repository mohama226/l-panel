#!/bin/bash

LP_VERSION="0.1.0"

LP_DIR="/opt/l-panel"
LP_INSTALLER="$LP_DIR/installer"


lp_header()
{
clear

echo "================================================"
echo "              L-PANEL v$LP_VERSION"
echo "================================================"
echo
}


lp_message()
{
echo
echo "$1"
echo
read -p "Press Enter..."
}


lp_run()
{
if [ -f "$LP_INSTALLER/$1" ]; then

bash "$LP_INSTALLER/$1"

else

lp_message "Module not found: $1"

fi
}
