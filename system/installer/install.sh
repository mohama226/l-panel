#!/bin/bash

clear
echo "=========================================="
echo "     L-PANEL Installer (PHP + PostgreSQL)"
echo "=========================================="

# -----------------------------
# Detect OS
# -----------------------------
if [ -f /etc/almalinux-release ]; then
    OS="almalinux"
elif [ -f /etc/lsb-release ]; then
    OS="ubuntu"
else
    echo "Unsupported OS"
    exit 1
fi

echo "[+] OS detected: $OS"

# -----------------------------
# Update system
# -----------------------------
echo "[+] Updating system..."
if [ "$OS" = "almalinux" ]; then
    yum update -y
else
    apt update -y
    apt upgrade -y
fi

# -----------------------------
# Install PHP + Extensions
# -----------------------------
echo "[+] Installing PHP 8.2..."

if [ "$OS" = "almalinux" ]; then
    yum install -y epel-release
    yum install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm
    yum module reset php -y
    yum module enable php:remi-8.2 -y
    yum install -y php php-cli php-common php-pdo php-pgsql php-json php-mbstring php-curl php-xml php-opcache
else
    apt install -y software-properties-common
    add-apt-repository ppa:ondrej/php -y
    apt update -y
    apt install -y php8.2 php8.2-cli php8.2-common php8.2-pgsql php8.2-mbstring php8.2-curl php8.2-xml php8.2-opcache
fi

# -----------------------------
# Install PostgreSQL
# -----------------------------
echo "[+] Installing PostgreSQL..."

if [ "$OS" = "almalinux" ]; then
    yum install -y postgresql-server postgresql-contrib
    postgresql-setup --initdb
    systemctl enable postgresql
    systemctl start postgresql
else
    apt install -y postgresql postgresql-contrib
    systemctl enable postgresql
    systemctl start postgresql
fi

# -----------------------------
# Create database
# -----------------------------
echo "[+] Creating database lpanel..."

sudo -u postgres psql <<EOF
CREATE DATABASE lpanel;
CREATE USER lpaneluser WITH PASSWORD 'lpanelpass';
GRANT ALL PRIVILEGES ON DATABASE lpanel TO lpaneluser;
EOF

# -----------------------------
# Clone project
# -----------------------------
echo "[+] Cloning project from GitHub..."

cd /var/www/
rm -rf l-panel
git clone https://github.com/mohama226/l-panel.git

chmod -R 755 /var/www/l-panel
chown -R $USER:$USER /var/www/l-panel

# -----------------------------
# Create config.php
# -----------------------------
echo "[+] Creating config.php..."

cat > /var/www/l-panel/system/config.php <<EOF
<?php
return [
    'db_host' => 'localhost',
    'db_name' => 'lpanel',
    'db_user' => 'lpaneluser',
    'db_pass' => 'lpanelpass',
];
EOF

# -----------------------------
# Create Apache/Nginx config (optional)
# -----------------------------
echo "[+] Creating web server config..."

if command -v apache2 >/dev/null 2>&1 || command -v httpd >/dev/null 2>&1; then
    echo "[+] Apache detected, configuring..."
    cat > /etc/httpd/conf.d/lpanel.conf <<EOF
<VirtualHost *:80>
    DocumentRoot /var/www/l-panel/public
    <Directory /var/www/l-panel/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
    systemctl restart httpd || systemctl restart apache2
fi

# -----------------------------
# Finish
# -----------------------------
echo "=========================================="
echo "   ✔ نصب پنل با موفقیت انجام شد"
echo "   آدرس پنل:  http://YOUR-IP/login.php"
echo "=========================================="
