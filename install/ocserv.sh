#!/usr/bin/env bash


source "$(dirname "$0")/variables.sh"


if [ ! -f "$CONFIG_DIR/install.conf" ]

then

exit 0

fi


INSTALL_OCSERV=$(grep INSTALL_OCSERV $CONFIG_DIR/install.conf | cut -d= -f2)



if [ "$INSTALL_OCSERV" = "y" ] || [ "$INSTALL_OCSERV" = "Y" ]

then


apt install -y ocserv


systemctl enable ocserv


systemctl restart ocserv


echo "Ocserv installed."


else


echo "Ocserv skipped."


fi
