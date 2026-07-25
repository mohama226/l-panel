#!/usr/bin/env bash
set -e

echo ""
echo "=============================================="
echo "      L-Panel PHP Auto Installer"
echo "=============================================="
echo ""

read -p "Super Admin Username: " SUPERADMIN_USER
read -p "Super Admin Password: " SUPERADMIN_PASS
read -p "Panel Port (e.g., 80 or 8080): " PANEL_PORT

SUPERADMIN_USER=$(echo "$SUPERADMIN_USER" | tr -cd 'a-zA-Z0-9_-')
SUPERADMIN_PASS=$(echo "$SUPERADMIN_PASS" | tr -cd 'a-zA-Z0-9_-')
PANEL_PORT=$(echo "$PANEL_PORT" | tr -cd '0-9')

if [[ -z "$SUPERADMIN_USER" || -z "$SUPERADMIN_PASS" || -z "$PANEL_PORT" ]]; then
    echo "Invalid input. Installation aborted."
    exit 1
fi

REPO_URL="https://github.com/mohama226/l-panel.git"
INSTALL_DIR="/var/www/lpanel"
DB_NAME="lpanel"
DB_USER="lpanel_user"
DB_PASS="$(openssl rand -hex 16)"

echo "[*] Cleaning previous installation..."

rm -rf /var/www/lpanel
rm -f /etc/httpd/conf.d/lpanel.conf
rm -f /usr/bin/l-panel

# Restart httpd only if installed
if systemctl list-unit-files | grep -q httpd; then
    systemctl restart httpd || true
fi

echo "[*] Installing required packages..."
dnf install -y epel-release
dnf install -y httpd php php-mysqlnd mariadb-server git curl unzip policycoreutils-python-utils firewalld

systemctl enable httpd
systemctl start httpd

systemctl enable mariadb
systemctl start mariadb

echo "[*] Resetting database..."
mysql -u root <<EOF
DROP DATABASE IF EXISTS ${DB_NAME};
DROP USER IF EXISTS '${DB_USER}'@'localhost';
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "[*] Cloning repository..."
git clone "$REPO_URL" "$INSTALL_DIR"

SQL_FILE="${INSTALL_DIR}/sql/schema.sql"
if [[ ! -f "$SQL_FILE" ]]; then
    echo "[!] ERROR: schema.sql not found!"
    exit 1
fi

echo "[*] Importing SQL..."
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$SQL_FILE"

HASHED_PASS=$(php -r "echo password_hash('$SUPERADMIN_PASS', PASSWORD_DEFAULT);")
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" <<EOF
INSERT INTO admins (username, password, role)
VALUES ('${SUPERADMIN_USER}', '${HASHED_PASS}', 'superadmin');
EOF

echo "[*] Configuring Apache..."

CONF="/etc/httpd/conf.d/lpanel.conf"

cat > "$CONF" <<EOF
Listen ${PANEL_PORT}

<VirtualHost *:${PANEL_PORT}>
    DocumentRoot ${INSTALL_DIR}/public
    <Directory ${INSTALL_DIR}/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

echo "[*] Allowing Apache to use port ${PANEL_PORT} in SELinux..."
semanage port -a -t http_port_t -p tcp ${PANEL_PORT} 2>/dev/null || \
semanage port -m -t http_port_t -p tcp ${PANEL_PORT}

echo "[*] Opening firewall port..."
firewall-cmd --add-port=${PANEL_PORT}/tcp --permanent
firewall-cmd --reload

echo "[*] Restarting Apache..."
systemctl restart httpd

echo "[*] Installing CLI command..."
cp "${INSTALL_DIR}/cli/l-panel.sh" /usr/bin/l-panel
chmod +x /usr/bin/l-panel

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
echo "CLI Command Installed: l-panel"
echo ""
