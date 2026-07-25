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
read -p "نام کاربری سوپر ادمین: " SUPERADMIN_USER
read -p "رمز سوپر ادمین: " SUPERADMIN_PASS
read -p "پنل روی چه پورتی اجرا شود؟ (مثال: 80 یا 8080): " PANEL_PORT

if [[ -z "$SUPERADMIN_USER" || -z "$SUPERADMIN_PASS" || -z "$PANEL_PORT" ]]; then
    echo "ورودی‌ها نامعتبر هستند."
    exit 1
fi

# -----------------------------
# Variables
# -----------------------------
REPO_URL="https://github.com/mohama226/l-panel.git"
INSTALL_DIR="/var/www/lpanel"
DB_NAME="lpanel"
DB_USER="lpanel_user"
DB_PASS="$(openssl rand -hex 12)"

# -----------------------------
# Detect OS
# -----------------------------
echo "[*] Detecting OS..."
. /etc/os-release
OS_ID=$ID
echo "[*] OS: $OS_ID"

# -----------------------------
# Install packages
# -----------------------------
echo "[*] Installing packages..."

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
echo "[*] Creating database..."
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

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
    echo "[!] ERROR: فایل schema.sql پیدا نشد!"
    echo "مسیر مورد انتظار: $SQL_FILE"
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
echo "   نصب با موفقیت انجام شد!"
echo "=============================================="
echo ""
echo "آدرس پنل: http://YOUR-IP:${PANEL_PORT}/"
echo "سوپر ادمین:"
echo "  یوزرنیم: ${SUPERADMIN_USER}"
echo "  پسورد: ${SUPERADMIN_PASS}"
echo ""
echo "دیتابیس:"
echo "  DB Name: ${DB_NAME}"
echo "  DB User: ${DB_USER}"
echo "  DB Pass: ${DB_PASS}"
echo ""
