#!/bin/bash

clear
echo "=========================================="
echo "        L-PANEL Auto Installer"
echo "=========================================="

# -----------------------------
# Ask for admin credentials
# -----------------------------
echo ""
read -p "Enter superadmin username: " ADMIN_USER
read -p "Enter superadmin password: " ADMIN_PASS
read -p "Enter panel port (default 8080): " PANEL_PORT

if [ -z "$PANEL_PORT" ]; then
    PANEL_PORT=8080
fi

echo ""
echo "[+] Superadmin: $ADMIN_USER"
echo "[+] Port: $PANEL_PORT"
echo ""

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
    'panel_port' => '$PANEL_PORT'
];
EOF

# -----------------------------
# Insert superadmin into database
# -----------------------------
HASHED_PASS=$(php -r "echo password_hash('$ADMIN_PASS', PASSWORD_DEFAULT);")

sudo -u postgres psql lpanel <<EOF
INSERT INTO users (username, password, role, status)
VALUES ('$ADMIN_USER', '$HASHED_PASS', 'owner', true);
EOF

# -----------------------------
# Create systemd service
# -----------------------------
echo "[+] Creating systemd service..."

cat > /etc/systemd/system/lpanel.service <<EOF
[Unit]
Description=L-PANEL PHP Service

[Service]
ExecStart=/usr/bin/php -S 0.0.0.0:$PANEL_PORT -t /var/www/l-panel/public
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable lpanel
systemctl start lpanel

# -----------------------------
# Create CLI command: l-panel
# -----------------------------
echo "[+] Creating CLI command..."

cat > /usr/bin/l-panel <<EOF
#!/bin/bash

clear
echo "=========================================="
echo "           L-PANEL CLI Manager"
echo "=========================================="
echo "1) Update panel from GitHub"
echo "2) Restart panel service"
echo "3) Stop panel service"
echo "4) Start panel service"
echo "5) Exit"
echo "------------------------------------------"
read -p "Choose an option: " CHOICE

case \$CHOICE in
    1)
        echo "[+] Updating from GitHub..."
        cd /var/www/l-panel
        git pull
        systemctl restart lpanel
        echo "[+] Update completed."
        ;;
    2)
        systemctl restart lpanel
        echo "[+] Service restarted."
        ;;
    3)
        systemctl stop lpanel
        echo "[+] Service stopped."
        ;;
    4)
        systemctl start lpanel
        echo "[+] Service started."
        ;;
    *)
        exit 0
        ;;
esac
EOF

chmod +x /usr/bin/l-panel

# -----------------------------
# Finish
# -----------------------------
echo "=========================================="
echo "   ✔ Installation completed successfully"
echo "   Panel URL:  http://YOUR-IP:$PANEL_PORT/login.php"
echo "   CLI Command:  l-panel"
echo "=========================================="
