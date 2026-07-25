#!/usr/bin/env bash
# L-Panel PHP Installer
# Auto OS Detection + Auto Package Install + Auto Setup

set -e

REPO_URL="https://github.com/mohama226/l-panel.git"
INSTALL_DIR="/var/www/lpanel"
DB_NAME="lpanel"
DB_USER="lpanel_user"
DB_PASS="$(openssl rand -hex 12)"   # رمز تصادفی امن

echo ""
echo "=============================================="
echo "     L-Panel PHP Auto Installer"
echo "=============================================="
echo ""

# -----------------------------
# Detect OS
# -----------------------------
echo "[*] Detecting operating system..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_ID=$ID
else
    echo "[!] Cannot detect OS."
    exit 1
fi

echo "[*] OS detected: $OS_ID"

# -----------------------------
# Install Packages
# -----------------------------
echo "[*] Installing required packages..."

if [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" ]]; then
    apt update -y
    apt install -y apache2 php php-cli php-mysql php-json php-curl php-mbstring php-xml git mariadb-server unzip curl
    systemctl enable apache2
    systemctl start apache2

elif [[ "$OS_ID" == "almalinux" || "$OS_ID" == "centos" || "$OS_ID" == "rhel" ]]; then
    dnf install -y epel-release
    dnf install -y httpd php php-cli php-mysqlnd php-json php-mbstring php-xml git mariadb-server unzip curl
    systemctl enable httpd
    systemctl start httpd

else
    echo "[!] Unsupported OS: $OS_ID"
    exit 1
fi

# -----------------------------
# Start MariaDB
# -----------------------------
echo "[*] Starting MariaDB..."
systemctl enable mariadb || true
systemctl start mariadb || true

# -----------------------------
# Create Database
# -----------------------------
echo "[*] Creating database + user..."

mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "[*] Database created:"
echo "    DB Name: ${DB_NAME}"
echo "    DB User: ${DB_USER}"
echo "    DB Pass: ${DB_PASS}"

# -----------------------------
# Clone Repository
# -----------------------------
echo "[*] Cloning L-Panel repository..."

rm -rf "$INSTALL_DIR"
git clone "$REPO_URL" "$INSTALL_DIR"

# -----------------------------
# Import SQL Schema
# -----------------------------
echo "[*] Importing SQL schema..."

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$INSTALL_DIR/php-panel/sql/schema.sql"

# -----------------------------
# Configure Apache
# -----------------------------
echo "[*] Configuring Apache..."

if [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" ]]; then
    cat >/etc/apache2/sites-available/lpanel.conf <<APACHECONF
<VirtualHost *:80>
    ServerName lpanel.local
    DocumentRoot ${INSTALL_DIR}/php-panel/public

    <Directory ${INSTALL_DIR}/php-panel/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
APACHECONF

    a2ensite lpanel.conf
    a2enmod rewrite
    systemctl reload apache2

else
    cat >/etc/httpd/conf.d/lpanel.conf <<APACHECONF
<VirtualHost *:80>
    ServerName lpanel.local
    DocumentRoot ${INSTALL_DIR}/php-panel/public

    <Directory ${INSTALL_DIR}/php-panel/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
APACHECONF

    systemctl reload httpd
fi

# -----------------------------
# Permissions
# -----------------------------
echo "[*] Setting permissions..."

chown -R apache:apache "$INSTALL_DIR" 2>/dev/null || chown -R www-data:www-data "$INSTALL_DIR"

echo ""
echo "=============================================="
echo "   Installation Completed Successfully!"
echo "=============================================="
echo ""
echo "Panel URL: http://YOUR-SERVER-IP/"
echo "Database Info:"
echo "  DB Name: ${DB_NAME}"
echo "  DB User: ${DB_USER}"
echo "  DB Pass: ${DB_PASS}"
echo ""
echo "Enjoy your L-Panel PHP!"
