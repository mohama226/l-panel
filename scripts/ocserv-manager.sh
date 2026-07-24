#!/bin/bash


ACTION=$1
USERNAME=$2
PASSWORD=$3


PASSFILE="/etc/ocserv/ocpasswd"


case "$ACTION" in


add)

if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
exit 1
fi


echo "$PASSWORD" | /usr/bin/ocpasswd \
-c "$PASSFILE" \
"$USERNAME"


systemctl restart ocserv


;;


delete)


/usr/bin/ocpasswd \
-c "$PASSFILE" \
-d "$USERNAME"


systemctl restart ocserv


;;


password)


echo "$PASSWORD" | /usr/bin/ocpasswd \
-c "$PASSFILE" \
"$USERNAME"


systemctl restart ocserv


;;


*)

echo "invalid action"
exit 1

;;

esac
