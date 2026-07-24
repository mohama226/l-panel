#!/bin/bash

OCSERV_PASS="/etc/ocserv/ocpasswd"
SERVICE="ocserv"

ACTION=$1


if [ "$ACTION" = "add" ]; then

USERNAME=$2
PASSWORD=$3


if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
    exit 1
fi


/usr/bin/ocpasswd \
-c "$OCSERV_PASS" \
-g users \
"$USERNAME" <<EOF
$PASSWORD
$PASSWORD
EOF


systemctl restart $SERVICE


exit 0

fi



if [ "$ACTION" = "delete" ]; then

USERNAME=$2


/usr/bin/ocpasswd \
-c "$OCSERV_PASS" \
-d "$USERNAME"


systemctl restart $SERVICE


exit 0

fi



exit 1
