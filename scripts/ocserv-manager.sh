#!/bin/bash

ACTION=$1
USERNAME=$2
PASSWORD=$3

OCFILE="/etc/ocserv/ocpasswd"


case "$ACTION" in

add)

echo "$PASSWORD" | /usr/bin/ocpasswd -c "$OCFILE" "$USERNAME"

/usr/bin/systemctl restart ocserv

;;

delete)

 /usr/bin/ocpasswd -c "$OCFILE" -d "$USERNAME"

/usr/bin/systemctl restart ocserv

;;

restart)

/usr/bin/systemctl restart ocserv

;;

*)

echo "Invalid action"
exit 1

;;

esac
