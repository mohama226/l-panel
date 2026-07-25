#!/usr/bin/env bash
# install/install.sh

set -e

REPO_URL="https://github.com/mohama226/l-panel.git"
APP_DIR="/var/www/lpanel"
DB_NAME="lpanel"
DB_USER="lpanel_user"
DB_PASS="strong_password_here"

echo "[*] Detecting OS..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_ID=$ID
else
    echo "Cannot detect OS."
    exit 1
fi

echo "[*] Updating packages..."
if [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" ]]; then
    apt update
    apt install -y apache2 php php-mysql git mariadb-server
    systemctl enable apache2
    systemctl start apache2
elif [[ "$OS_ID" == "almalinux" || "$OS_ID" == "centos" || "$OS_ID" == "rhel" ]]; then
    dnf install -y httpd php php-mysqlnd git mariadb-server
    systemctl enable httpd
    systemctl start httpd
else
    echo "Unsupported OS: $OS_ID"
    exit 1
fi

echo "[*] Starting MariaDB..."
systemctl enable mariadb || true
systemctl start mariadb || true

echo "[*] Creating database and user..."
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "[*] Cloning repository..."
if [ ! -d "$APP_DIR" ]; then
    git clone "$REPO_URL" "$APP_DIR"
else
    cd "$APP_DIR"
    git pull
fi

echo "[*] Copying PHP panel..."
mkdir -p "$APP_DIR/php-panel/public"
mkdir -p "$APP_DIR/php-panel/app"
mkdir -p "$APP_DIR/php-panel/sql"
mkdir -p "$APP_DIR/php-panel/install"

# فرض می‌کنیم فایل‌هایی که بالا دادم رو خودت در ریپو می‌گذاری
# این اسکریپت فقط اسکیمای دیتابیس را اجرا می‌کند:

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$APP_DIR/php-panel/sql/schema.sql"

echo "[*] Setting permissions..."
chown -R www-data:www-data "$APP_DIR" || chown -R apache:apache "$APP_DIR"

echo "[*] Configuring Apache..."
if [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" ]]; then
    cat >/etc/apache2/sites-available/lpanel.conf <<APACHECONF
<VirtualHost *:80>
    ServerName lpanel.local
    DocumentRoot ${APP_DIR}/php-panel/public

    <Directory ${APP_DIR}/php-panel/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
APACHECONF

    a2ensite lpanel.conf
    systemctl reload apache2
else
    cat >/etc/httpd/conf.d/lpanel.conf <<APACHECONF
<VirtualHost *:80>
    ServerName lpanel.local
    DocumentRoot ${APP_DIR}/php-panel/public

    <Directory ${APP_DIR}/php-panel/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
APACHECONF

    systemctl reload httpd
fi

echo "[*] Installation finished."
echo "Open: http://your-server-ip/ (or configure DNS for lpanel.local)"
