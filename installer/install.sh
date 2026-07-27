############################################
# L-PANEL INSTALL SETTINGS
############################################

echo "
L-PANEL Initial Setup
"

read -p "Enter Super Admin Username: " ADMIN_USERNAME

while true; do

    read -s -p "Enter Super Admin Password: " ADMIN_PASSWORD
    echo

    read -s -p "Confirm Password: " ADMIN_PASSWORD_CONFIRM
    echo

    if [ "$ADMIN_PASSWORD" = "$ADMIN_PASSWORD_CONFIRM" ]; then
        break
    else
        echo "Passwords do not match"
    fi

done

read -p "Enter Panel Port (default 80): " PANEL_PORT
[ -z "$PANEL_PORT" ] && PANEL_PORT=80

echo "
Admin Username: $ADMIN_USERNAME
Panel Port: $PANEL_PORT
"
