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

case "$opt" in
    1)
        echo ""
        echo "[*] Updating panel..."

        cd "$INSTALL_DIR" || { echo "Install dir not found!"; exit 1; }

        # Fix Git ownership issue automatically
        git config --global --add safe.directory "$INSTALL_DIR"

        BEFORE=$(mktemp)
        AFTER=$(mktemp)
        CHANGED=$(mktemp)

        git ls-files > "$BEFORE"

        echo ""
        echo "Progress:"
        for i in 10 30 50 70 90 100; do
            printf "\r[%-50s] %3d%%" "$(printf '#%.0s' $(seq 1 $((i/2))))" "$i"
            sleep 0.2
        done
        echo ""

        git fetch --all >/dev/null 2>&1
        git pull

        git ls-files > "$AFTER"

        comm -3 "$BEFORE" "$AFTER" > "$CHANGED"

        COUNT=$(wc -l < "$CHANGED")
        DATE_STR=$(date +"%Y-%m-%d %H:%M:%S")
        echo "$DATE_STR" > "$LAST_UPDATE_FILE"

        echo ""
        echo "[*] Update completed at: $DATE_STR"
        echo "[*] Total changed files: $COUNT"
        echo ""

        if [ "$COUNT" -gt 0 ]; then
            echo "Changed files:"
            echo "-----------------------------"
            cat "$CHANGED"
            echo "-----------------------------"
        else
            echo "No file changes detected."
        fi

        rm -f "$BEFORE" "$AFTER" "$CHANGED"
        ;;
    2)
        echo ""
        echo "[*] Restarting Apache..."
        systemctl restart httpd 2>/dev/null || systemctl restart apache2
        echo "[*] Apache restarted."
        ;;
    3)
        echo ""
        echo "[*] Panel Info:"
        echo "  Install dir: $INSTALL_DIR"

        if [ -f "$LAST_UPDATE_FILE" ]; then
            echo "  Last update: $(cat "$LAST_UPDATE_FILE")"
        else
            echo "  Last update: No update recorded yet."
        fi

        echo ""
        echo "  Git status:"
        cd "$INSTALL_DIR"
        git status -sb
        ;;
    *)
        echo "Invalid option."
        ;;
esac
