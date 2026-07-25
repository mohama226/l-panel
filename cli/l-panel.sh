#!/usr/bin/env bash

INSTALL_DIR="/var/www/lpanel"
LAST_UPDATE_FILE="${INSTALL_DIR}/.lpanel_last_update"

echo "=============================================="
echo "           L-Panel CLI Manager"
echo "=============================================="
echo ""
echo "1) Update Panel"
echo "2) Restart Apache"
echo "3) Show Panel Info"
echo ""
read -p "Choose an option: " opt

case $opt in
    1)
        echo "[*] Updating panel from GitHub..."
        cd "$INSTALL_DIR" || { echo "Install dir not found!"; exit 1; }

        git fetch --all
        git pull

        DATE_STR=$(date +"%Y-%m-%d %H:%M:%S")
        echo "$DATE_STR" > "$LAST_UPDATE_FILE"

        echo "[*] Update completed at: $DATE_STR"
        ;;
    2)
        echo "[*] Restarting Apache..."
        systemctl restart httpd
        echo "[*] Apache restarted."
        ;;
    3)
        echo "[*] Panel Info:"
        echo "  Install dir: $INSTALL_DIR"

        if [ -f "$LAST_UPDATE_FILE" ]; then
            LAST_UPDATE=$(cat "$LAST_UPDATE_FILE")
            echo "  Last update: $LAST_UPDATE"
        else
            echo "  Last update: No update recorded yet."
        fi
        ;;
    *)
        echo "Invalid option."
        ;;
esac
