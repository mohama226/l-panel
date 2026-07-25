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
        echo "[*] Updating panel from GitHub..."
        cd "$INSTALL_DIR" || { echo "Install dir not found!"; exit 1; }

        # قبل از آپدیت، وضعیت فعلی را ذخیره کن
        BEFORE_LIST=$(mktemp)
        AFTER_LIST=$(mktemp)

        git ls-files > "$BEFORE_LIST"

        # گرفتن آخرین تغییرات
        git fetch --all >/dev/null 2>&1

        # نوار پیشرفت ساده
        echo ""
        echo "Progress:"
        for i in 10 20 40 60 80 100; do
            printf "\r[%-50s] %3d%%" "$(printf '#%.0s' $(seq 1 $((i/2))))" "$i"
            sleep 0.2
        done
        echo ""

        git pull

        git ls-files > "$AFTER_LIST"

        # محاسبه فایل‌های تغییر کرده
        CHANGED_LIST=$(mktemp)
        comm -3 "$BEFORE_LIST" "$AFTER_LIST" > "$CHANGED_LIST"

        CHANGED_COUNT=$(wc -l < "$CHANGED_LIST")

        DATE_STR=$(date +"%Y-%m-%d %H:%M:%S")
        echo "$DATE_STR" > "$LAST_UPDATE_FILE"

        echo ""
        echo "[*] Update completed at: $DATE_STR"
        echo "[*] Total changed/added/removed files: $CHANGED_COUNT"
        echo ""

        if [ "$CHANGED_COUNT" -gt 0 ]; then
            echo "Changed files:"
            echo "-----------------------------"
            cat "$CHANGED_LIST"
            echo "-----------------------------"
        else
            echo "No file changes detected."
        fi

        rm -f "$BEFORE_LIST" "$AFTER_LIST" "$CHANGED_LIST"
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
            LAST_UPDATE=$(cat "$LAST_UPDATE_FILE")
            echo "  Last update: $LAST_UPDATE"
        else
            echo "  Last update: No update recorded yet."
        fi

        echo ""
        echo "  Git status:"
        cd "$INSTALL_DIR" || exit 1
        git status -sb
        ;;
    *)
        echo "Invalid option."
        ;;
esac
