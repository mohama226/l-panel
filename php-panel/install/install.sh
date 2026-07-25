#!/usr/bin/env bash
set -e

echo ""
echo "=============================================="
echo "      L-Panel PHP Auto Installer"
echo "=============================================="
echo ""

# -----------------------------
# Ask for Super Admin
# -----------------------------
read -p "Super Admin Username: " SUPERADMIN_USER
read -p "Super Admin Password: " SUPERADMIN_PASS
read -p "Panel Port (e.g., 80 or 8080): " PANEL_PORT

if [[ -z "$SUPERADMIN_USER" || -z "$SUPERADMIN_PASS" || -z "$PANEL_PORT" ]]; then
    echo "Invalid input. Installation aborted."
    exit 1
fi

# -----------------------------
# Variables
# -----------------------------
REPO_URL="https://github.com/mohama226/l-panel.git"
INSTALL_DIR="/var/www/lpanel"
DB_NAME="lpanel"
DB_USER="lpanel_user"
DB_PASS="$(openssl rand -hex 16)"

# -----------------------------
# Detect OS
# -----------------------------
echo "[*] Detecting OS..."
. /etc/os-release
OS_ID=$ID
echo "[*] OS Detected: $OS_ID"

# -----------------------------
# Install packages
# -----------------------------
echo "[*] Installing required packages..."

if [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" ]]; then
    apt update -y
    apt install -y apache2 php php-mysql mariadb-server git curl unzip
    systemctl enable apache2
    systemctl start apache2
else
    dnf install -y epel-release
    dnf install -y httpd php php-mysqlnd mariadb-server git curl unzip
    systemctl enable httpd
    systemctl start httpd
fi

# -----------------------------
# Start MariaDB
# -----------------------------
echo "[*] Starting MariaDB..."
systemctl enable mariadb || true
systemctl start mariadb || true

# -----------------------------
# Create DB
# -----------------------------
echo "[*] Creating database and user..."

mysql -u root <<EOF
DROP USER IF EXISTS '${DB_USER}'@'localhost';
DROP DATABASE IF EXISTS ${DB_NAME};
CREATE DATABASE ${DB_NAME};
CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "[*] Database created successfully."

# -----------------------------
# Clone repo
# -----------------------------
echo "[*] Cloning repository..."
rm -rf "$INSTALL_DIR"
git clone "$REPO_URL" "$INSTALL_DIR"

# -----------------------------
# Import SQL
# -----------------------------
SQL_FILE="${INSTALL_DIR}/php-panel/sql/schema.sql"

if [[ ! -f "$SQL_FILE" ]]; then
    echo "[!] ERROR: schema.sql not found!"
    echo "Expected path: $SQL_FILE"
    exit 1
fi

echo "[*] Importing SQL..."
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$SQL_FILE"

# -----------------------------
# Insert Super Admin
# -----------------------------
HASHED_PASS=$(php -r "echo password_hash('$SUPERADMIN_PASS', PASSWORD_DEFAULT);")

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" <<EOF
INSERT INTO admins (username, password, role)
VALUES ('${SUPERADMIN_USER}', '${HASHED_PASS}', 'superadmin');
EOF

# -----------------------------
# Apache config
# -----------------------------
echo "[*] Configuring Apache..."

if [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" ]]; then
    CONF="/etc/apache2/sites-available/lpanel.conf"
else
    CONF="/etc/httpd/conf.d/lpanel.conf"
fi

cat > "$CONF" <<EOF
<VirtualHost *:${PANEL_PORT}>
    DocumentRoot ${INSTALL_DIR}/php-panel/public
    <Directory ${INSTALL_DIR}/php-panel/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

if [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" ]]; then
    a2ensite lpanel.conf
    a2enmod rewrite
    systemctl reload apache2
else
    systemctl reload httpd
fi

# -----------------------------
# Permissions
# -----------------------------
chown -R apache:apache "$INSTALL_DIR" 2>/dev/null || chown -R www-data:www-data "$INSTALL_DIR"

echo ""
echo "=============================================="
echo "   Installation Completed Successfully!"
echo "=============================================="
echo ""
echo "Panel URL: http://YOUR-IP:${PANEL_PORT}/"
echo ""
echo "Super Admin:"
echo "  Username: ${SUPERADMIN_USER}"
echo "  Password: ${SUPERADMIN_PASS}"
echo ""
echo "Database:"
echo "  DB Name: ${DB_NAME}"
echo "  DB User: ${DB_USER}"
echo "  DB Pass: ${DB_PASS}"
echo ""
