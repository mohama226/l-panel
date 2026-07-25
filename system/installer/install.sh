#!/bin/bash

clear
echo "=========================================="
echo "        L-PANEL Smart Installer"
echo "=========================================="

INSTALL_PATH="/var/www/l-panel"

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
# Install git
# -----------------------------
echo "[+] Checking git..."
if ! command -v git &> /dev/null; then
    echo "[+] Installing git..."
    if [ "$OS" = "almalinux" ]; then
        yum install -y git
    else
        apt install -y git
    fi
else
    echo "[+] git already installed."
fi

# -----------------------------
# Install PHP + Extensions
# -----------------------------
echo "[+] Checking PHP..."
if ! command -v php &> /dev/null; then
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
else
    echo "[+] PHP already installed."
fi

# -----------------------------
# Install PostgreSQL
# -----------------------------
echo "[+] Checking PostgreSQL..."
if ! command -v psql &> /dev/null; then
    echo "[+] Installing PostgreSQL..."
    if [ "$OS" = "almalinux" ]; then
        yum install -y postgresql-server postgresql-contrib
        systemctl enable postgresql
        systemctl start postgresql
    else
        apt install -y postgresql postgresql-contrib
        systemctl enable postgresql
        systemctl start postgresql
    fi
else
    echo "[+] PostgreSQL already installed."
fi

# -----------------------------
# Create database if not exists
# -----------------------------
echo "[+] Checking database..."
sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='lpanel'" | grep -q 1
if [ $? -ne 0 ]; then
    echo "[+] Creating database lpanel..."
    sudo -u postgres psql <<EOF
CREATE DATABASE lpanel;
EOF
else
    echo "[+] Database already exists."
fi

# -----------------------------
# Create user if not exists
# -----------------------------
sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='lpaneluser'" | grep -q 1
if [ $? -ne 0 ]; then
    echo "[+] Creating PostgreSQL user..."
    sudo -u postgres psql <<EOF
CREATE USER lpaneluser WITH PASSWORD 'lpanelpass';
GRANT ALL PRIVILEGES ON DATABASE lpanel TO lpaneluser;
EOF
else
    echo "[+] PostgreSQL user already exists."
fi

# -----------------------------
# Clone or Update project
# -----------------------------
echo "[+] Checking project folder..."

if [ -d "$INSTALL_PATH" ]; then
    echo "[+] Project exists → updating..."
    cd $INSTALL_PATH
    git pull
else
    echo "[+] Project not found → cloning..."
    mkdir -p /var/www/
    cd /var/www/
    git clone https://github.com/mohama226/l-panel.git
fi

chmod -R 755 $INSTALL_PATH
chown -R $USER:$USER $INSTALL_PATH

# -----------------------------
# Create config.php
# -----------------------------
echo "[+] Updating config.php..."

cat > $INSTALL_PATH/system/config.php <<EOF
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
# Create users table if not exists
# -----------------------------
echo "[+] Checking users table..."

sudo -u postgres psql lpanel <<EOF
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(64),
    password VARCHAR(255),
    role VARCHAR(20),
    status BOOLEAN DEFAULT true
);
EOF

# -----------------------------
# Insert superadmin if not exists
# -----------------------------
echo "[+] Checking superadmin..."

HASHED_PASS=$(php -r "echo password_hash('$ADMIN_PASS', PASSWORD_DEFAULT);")

sudo -u postgres psql lpanel <<EOF
INSERT INTO users (username, password, role, status)
SELECT '$ADMIN_USER', '$HASHED_PASS', 'owner', true
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username='$ADMIN_USER');
EOF

# -----------------------------
# Create or update systemd service
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
systemctl restart lpanel

# -----------------------------
# Create CLI command
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
echo "   ✔ Smart install/update completed"
echo "   Panel URL:  http://YOUR-IP:$PANEL_PORT/login.php"
echo "   CLI Command:  l-panel"
echo "=========================================="
