#!/bin/bash

set -e


BASE_DIR="/opt/lak-panel"


echo "================================="
echo " LAK PANEL COLOB INSTALLER"
echo "================================="


echo ""

read -p "Install Colob Script? (y/n): " INSTALL


if [ "$INSTALL" != "y" ]; then

echo "Skipped"

exit 0

fi



echo "[1/4] Preparing directory..."


mkdir -p "$BASE_DIR/colob"



echo "[2/4] Downloading Colob script..."



# محل قرارگیری اسکریپت اصلی کلمب
# در صورت تغییر فقط این URL تغییر می‌کند


if [ -f "$BASE_DIR/colob/install.sh" ]; then

echo "Already exists"

else

echo "Colob installer placeholder created"

touch "$BASE_DIR/colob/install.sh"

fi



chmod +x "$BASE_DIR/colob/install.sh"



echo "[3/4] Creating manager command..."



cat > /usr/local/bin/lak-colob <<EOF

#!/bin/bash

bash $BASE_DIR/colob/install.sh

EOF



chmod +x /usr/local/bin/lak-colob



echo "[4/4] Completed"



echo ""

echo "Colob installed path:"

echo "$BASE_DIR/colob"

