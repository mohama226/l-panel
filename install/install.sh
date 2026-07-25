#!/usr/bin/env bash
set -e

echo "[*] Cleaning previous installation..."

rm -rf /var/www/lpanel/php-panel
rm -rf /var/www/lpanel/*
rm -f /etc/httpd/conf.d/lpanel.conf
rm -f /usr/bin/l-panel

systemctl restart httpd

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

REPO_URL="https://github.com/mohama226/l-panel.git"
INSTALL_DIR="/var/www/lpanel"
DB_NAME="lpanel"
DB_USER="lpanel_user"
DB_PASS="$(openssl rand -hex 16)"

dnf install -y epel-release httpd php php-mysqlnd mariadb-server git curl unzip policycoreutils-python-utils firewalld

systemctl enable httpd
systemctl start httpd
systemctl enable mariadb
systemctl start mariadb

mysql -u root <<EOF
DROP DATABASE IF EXISTS ${DB_NAME};
DROP USER IF EXISTS '${DB_USER}'@'localhost';
CREATE DATABASE ${DB_NAME};
CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

git clone "$REPO_URL" "$INSTALL_DIR"

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "${INSTALL_DIR}/sql/schema.sql"

HASHED_PASS=$(php -r "echo password_hash('$SUPERADMIN_PASS', PASSWORD_DEFAULT);")
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" <<EOF
INSERT INTO admins (username, password, role)
VALUES ('${SUPERADMIN_USER}', '${HASHED_PASS}', 'superadmin');
EOF

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

semanage port -a -t http_port_t -p tcp ${PANEL_PORT} 2>/dev/null || \
semanage port -m -t http_port_t -p tcp ${PANEL_PORT}

firewall-cmd --add-port=${PANEL_PORT}/tcp --permanent
firewall-cmd --reload

systemctl restart httpd

cp "${INSTALL_DIR}/cli/l-panel.sh" /usr/bin/l-panel
chmod +x /usr/bin/l-panel

echo "Installation Completed!"
