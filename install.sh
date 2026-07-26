#!/usr/bin/env bash

###############################################################################
#
# L-Panel Installer
#
# https://github.com/mohama226/l-panel
#
###############################################################################

set -e

VERSION="1.0.0"

PROJECT_NAME="L-Panel"

REPO="https://github.com/mohama226/l-panel.git"

INSTALL_DIR="/opt/l-panel"

WEB_ROOT="/opt/l-panel/public"

NGINX_CONF="/etc/nginx/conf.d/l-panel.conf"

ENV_FILE="$INSTALL_DIR/.env"

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
NC="\033[0m"

print_line() {
    echo "------------------------------------------------------------"
}

title() {

clear

echo -e "${BLUE}"

echo "############################################################"

echo "#                                                          #"

echo "#                 L-Panel Installer                        #"

echo "#                                                          #"

echo "#                  Version ${VERSION}                          #"

echo "#                                                          #"

echo "############################################################"

echo -e "${NC}"

}

success() {

echo -e "${GREEN}[OK]${NC} $1"

}

warning() {

echo -e "${YELLOW}[WARN]${NC} $1"

}

error() {

echo -e "${RED}[ERROR]${NC} $1"

exit 1

}

check_root() {

if [ "$EUID" -ne 0 ]; then

error "Please run installer as root."

fi

}

detect_os() {

if [ ! -f /etc/os-release ]; then

error "Cannot detect operating system."

fi

source /etc/os-release

OS="$ID"

VERSION_ID="$VERSION_ID"

case "$OS" in

ubuntu)

PACKAGE_MANAGER="apt"

;;

debian)

PACKAGE_MANAGER="apt"

;;

almalinux)

PACKAGE_MANAGER="dnf"

;;

rocky)

PACKAGE_MANAGER="dnf"

;;

centos)

PACKAGE_MANAGER="yum"

;;

*)

error "Unsupported operating system."

;;

esac

success "Operating System : $PRETTY_NAME"

success "Package Manager : $PACKAGE_MANAGER"

}

update_system() {

print_line

echo "Updating repositories..."

case "$PACKAGE_MANAGER" in

apt)

apt update

;;

dnf)

dnf makecache

;;

yum)

yum makecache

;;

esac

success "Repository updated."

}

install_base_packages() {

print_line

echo "Installing required packages..."

case "$PACKAGE_MANAGER" in

apt)

apt install -y \
git \
curl \
wget \
unzip \
zip \
tar \
ca-certificates \
software-properties-common

;;

dnf)

dnf install -y \
git \
curl \
wget \
unzip \
zip \
tar

;;

yum)

yum install -y \
git \
curl \
wget \
unzip \
zip \
tar

;;

esac

success "Base packages installed."

}

ask_questions() {

print_line

echo "L-Panel Configuration"

echo

read -rp "Super Admin Username : " ADMIN_USER

while true
do

read -rsp "Super Admin Password : " ADMIN_PASS

echo

read -rsp "Confirm Password : " ADMIN_PASS2

echo

if [ "$ADMIN_PASS" = "$ADMIN_PASS2" ]; then

break

fi

echo

echo "Passwords do not match."

done

read -rp "Panel Port [8080] : " PANEL_PORT

if [ -z "$PANEL_PORT" ]; then

PANEL_PORT=8080

fi

read -rp "Database Password (Leave empty for auto) : " DB_PASS

if [ -z "$DB_PASS" ]; then

DB_PASS=$(openssl rand -base64 24)
fi

}
install_php() {

print_line

echo "Installing PHP..."

case "$PACKAGE_MANAGER" in

apt)

export DEBIAN_FRONTEND=noninteractive

apt install -y \
php8.3 \
php8.3-cli \
php8.3-fpm \
php8.3-common \
php8.3-mysql \
php8.3-curl \
php8.3-mbstring \
php8.3-xml \
php8.3-bcmath \
php8.3-gd \
php8.3-intl \
php8.3-zip

PHP_BIN="/usr/bin/php"

PHP_FPM_SERVICE="php8.3-fpm"

;;

dnf)

dnf install -y epel-release

dnf install -y \
https://rpms.remirepo.net/enterprise/remi-release-9.rpm

dnf module reset php -y

dnf module enable php:remi-8.3 -y

dnf install -y \
php \
php-cli \
php-fpm \
php-common \
php-mysqlnd \
php-gd \
php-curl \
php-intl \
php-xml \
php-bcmath \
php-mbstring \
php-zip

PHP_BIN="/usr/bin/php"

PHP_FPM_SERVICE="php-fpm"

;;

yum)

yum install -y epel-release

yum install -y \
https://rpms.remirepo.net/enterprise/remi-release-8.rpm

yum module reset php -y

yum module enable php:remi-8.3 -y

yum install -y \
php \
php-cli \
php-fpm \
php-common \
php-mysqlnd \
php-gd \
php-curl \
php-intl \
php-xml \
php-bcmath \
php-mbstring \
php-zip

PHP_BIN="/usr/bin/php"

PHP_FPM_SERVICE="php-fpm"

;;

esac

systemctl enable "$PHP_FPM_SERVICE"

systemctl restart "$PHP_FPM_SERVICE"

success "PHP Installed"

"$PHP_BIN" -v

}

install_mariadb() {

print_line

echo "Installing MariaDB..."

case "$PACKAGE_MANAGER" in

apt)

apt install -y mariadb-server

;;

dnf)

dnf install -y mariadb-server

;;

yum)

yum install -y mariadb-server

;;

esac

systemctl enable mariadb

systemctl restart mariadb

success "MariaDB Installed"

}

install_nginx() {

print_line

echo "Installing Nginx..."

case "$PACKAGE_MANAGER" in

apt)

apt install -y nginx

;;

dnf)

dnf install -y nginx

;;

yum)

yum install -y nginx

;;

esac

systemctl enable nginx

systemctl restart nginx

success "Nginx Installed"

}

install_composer() {

print_line

echo "Installing Composer..."

EXPECTED_SIGNATURE=$(curl -fsSL https://composer.github.io/installer.sig)

php -r "copy('https://getcomposer.org/installer','composer-setup.php');"

ACTUAL_SIGNATURE=$(php -r "echo hash_file('sha384','composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then

rm composer-setup.php

error "Composer installer signature mismatch."

fi

php composer-setup.php \
--install-dir=/usr/local/bin \
--filename=composer

rm composer-setup.php

success "Composer Installed"

composer --version

}



prepare_install_directory() {

print_line

echo "Preparing installation..."

if [ -d "$INSTALL_DIR" ]; then

    warning "Installation directory already exists."

else

    mkdir -p "$(dirname "$INSTALL_DIR")"

fi

success "Ready."

}




download_project() {

print_line

echo "Downloading L-Panel..."

if [ -d "$INSTALL_DIR" ]; then

    if [ -d "$INSTALL_DIR/.git" ]; then

        echo "Existing L-Panel installation detected."

        cd "$INSTALL_DIR"

        git pull

    else

        echo "Directory exists but is not a git repository."

        read -rp "Remove existing directory? (yes/no): " REMOVE_DIR

        if [ "$REMOVE_DIR" = "yes" ]; then

            rm -rf "$INSTALL_DIR"

            git clone "$REPO" "$INSTALL_DIR"

        else

            error "Installation cancelled."

        fi

    fi

else

    git clone "$REPO" "$INSTALL_DIR"

mkdir -p "$INSTALL_DIR/storage/logs"
mkdir -p "$INSTALL_DIR/storage/cache"
mkdir -p "$INSTALL_DIR/storage/uploads"

fi


cd "$INSTALL_DIR"


composer install \
--no-dev \
--optimize-autoloader


success "Project downloaded."

}


create_database() {

print_line

echo "Configuring MariaDB..."

DB_NAME="lpanel"

DB_USER="lpanel"

mysql -uroot <<EOF

CREATE DATABASE IF NOT EXISTS ${DB_NAME}
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost'
IDENTIFIED BY '${DB_PASS}';

GRANT ALL PRIVILEGES
ON ${DB_NAME}.*
TO '${DB_USER}'@'localhost';

FLUSH PRIVILEGES;

EOF

success "Database created."

}

generate_app_key() {

APP_KEY=$(openssl rand -hex 32)

}

generate_env() {

print_line

echo "Generating .env..."

cat > "$ENV_FILE" <<EOF
APP_NAME=L-Panel
APP_ENV=production
APP_DEBUG=false
APP_URL=http://$(hostname -I | awk '{print $1}'):${PANEL_PORT}

APP_KEY=${APP_KEY}

DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=lpanel
DB_USERNAME=lpanel
DB_PASSWORD=${DB_PASS}

ADMIN_USERNAME=${ADMIN_USER}
ADMIN_PASSWORD=${ADMIN_PASS}

TIMEZONE=UTC

EOF

success ".env created."

}

configure_permissions() {

print_line

echo "Setting permissions..."

chown -R www-data:www-data "$INSTALL_DIR" 2>/dev/null || true
chown -R nginx:nginx "$INSTALL_DIR" 2>/dev/null || true

chmod -R 755 "$INSTALL_DIR"

chmod -R 775 "$INSTALL_DIR/storage"

success "Permissions configured."

}

configure_nginx() {

print_line

echo "Configuring Nginx..."

cat > "$NGINX_CONF" <<EOF
server {

    listen ${PANEL_PORT};

    server_name _;

    root ${WEB_ROOT};

    index index.php;

    client_max_body_size 100M;

    location / {

        try_files \$uri \$uri/ /index.php?\$query_string;

    }

    location ~ \.php$ {

        include fastcgi_params;

        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;

EOF

if [ "$PACKAGE_MANAGER" = "apt" ]; then

cat >> "$NGINX_CONF" <<EOF
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
EOF

else

cat >> "$NGINX_CONF" <<EOF
        fastcgi_pass unix:/run/php-fpm/www.sock;
EOF

fi

cat >> "$NGINX_CONF" <<EOF

    }

    location ~ /\. {

        deny all;

    }

}
EOF

nginx -t

systemctl restart nginx

success "Nginx configured."

}

create_superadmin() {

print_line

echo "Creating Super Admin..."

cd "$INSTALL_DIR"

php cli/install.php \
--username="$ADMIN_USER" \
--password="$ADMIN_PASS"

success "Super Admin created."

}
detect_web_user() {

print_line

echo "Detecting web server user..."

if id "www-data" >/dev/null 2>&1; then

WEB_USER="www-data"
WEB_GROUP="www-data"

elif id "nginx" >/dev/null 2>&1; then

WEB_USER="nginx"
WEB_GROUP="nginx"

elif id "apache" >/dev/null 2>&1; then

WEB_USER="apache"
WEB_GROUP="apache"

else

WEB_USER="root"
WEB_GROUP="root"

fi

success "Web User : ${WEB_USER}"

}

install_cli() {

print_line

echo "Installing CLI..."

cat >/usr/local/bin/l-panel <<'EOF'
#!/usr/bin/env bash

BASE="/opt/l-panel"

if [ $# -eq 0 ]; then

echo

echo "========================================="

echo "         L-Panel CLI"

echo "========================================="

echo

echo "1) Update"

echo "2) Backup"

echo "3) Restore"

echo "4) Change Panel Port"

echo "5) Restart Services"

echo "6) Repair"

echo "7) Status"

echo "8) Version"

echo "9) Uninstall"

echo "0) Exit"

echo

read -rp "Select: " opt

case "$opt" in

1)

bash "$BASE/update.sh"

;;

2)

bash "$BASE/backup.sh"

;;

3)

bash "$BASE/restore.sh"

;;

4)

bash "$BASE/change-port.sh"

;;

5)

systemctl restart nginx

systemctl restart mariadb

systemctl restart php-fpm 2>/dev/null || true

systemctl restart php8.3-fpm 2>/dev/null || true

;;

6)

bash "$BASE/repair.sh"

;;

7)

systemctl status nginx --no-pager

;;

8)

cat "$BASE/version"

;;

9)

bash "$BASE/uninstall.sh"

;;

*)

exit 0

;;

esac

exit 0

fi

case "$1" in

update)

bash "$BASE/update.sh"

;;

backup)

bash "$BASE/backup.sh"

;;

restore)

bash "$BASE/restore.sh"

;;

repair)

bash "$BASE/repair.sh"

;;

status)

systemctl status nginx --no-pager

;;

version)

cat "$BASE/version"

;;

*)

echo "Unknown command."

;;

esac

EOF

chmod +x /usr/local/bin/l-panel

success "CLI installed."

}

final_permissions() {

print_line

echo "Applying permissions..."

chown -R "${WEB_USER}:${WEB_GROUP}" "$INSTALL_DIR"

find "$INSTALL_DIR" -type d -exec chmod 755 {} \;

find "$INSTALL_DIR" -type f -exec chmod 644 {} \;

chmod -R 775 "$INSTALL_DIR/storage"

chmod +x /usr/local/bin/l-panel

success "Permissions applied."

}

create_version_file() {

echo "${VERSION}" > "${INSTALL_DIR}/version"

success "Version file created."

}
run_migrations() {

print_line

echo "Running database migrations..."

cd "$INSTALL_DIR"

if [ -f "cli/migrate.php" ]; then

php cli/migrate.php

success "Database migrated."

else

warning "Migration file not found. Skipping."

fi

}


save_install_info() {

cat > "$INSTALL_DIR/install.json" <<EOF
{
    "version": "${VERSION}",
    "installed_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "port": "${PANEL_PORT}",
    "database": "lpanel"
}
EOF

}


enable_firewall_port() {

print_line

echo "Opening firewall port..."

if command -v ufw >/dev/null 2>&1; then

ufw allow ${PANEL_PORT}/tcp || true

fi


if command -v firewall-cmd >/dev/null 2>&1; then

firewall-cmd \
--permanent \
--add-port=${PANEL_PORT}/tcp || true

firewall-cmd --reload || true

fi


success "Firewall configured."

}


restart_services() {

print_line

echo "Restarting services..."


systemctl restart nginx


if systemctl list-units --type=service | grep -q php8.3-fpm; then

systemctl restart php8.3-fpm

fi


if systemctl list-units --type=service | grep -q php-fpm; then

systemctl restart php-fpm

fi


systemctl restart mariadb


success "Services restarted."

}


installation_complete() {

SERVER_IP=$(hostname -I | awk '{print $1}')


clear

echo "Installing L-Panel CLI..."

install -m 755 scripts/l-panel /usr/local/bin/l-panel

echo "[OK] L-Panel CLI Installed"


echo

echo "===================================================="

echo

echo "          L-Panel Installation Completed"

echo

echo "===================================================="

echo

echo "Panel URL"

echo

echo "http://${SERVER_IP}:${PANEL_PORT}"

echo

echo "Super Admin"

echo

echo "Username : ${ADMIN_USER}"

echo

echo "Password : ********"

echo

echo "CLI Command"

echo

echo "l-panel"

echo

echo "===================================================="

echo

echo "Thank you for installing L-Panel."

}


main() {

title


check_root


detect_os


update_system


install_base_packages


ask_questions


install_php


install_mariadb


install_nginx


install_composer


prepare_install_directory


download_project


detect_web_user


create_database


generate_app_key


generate_env


configure_nginx


run_migrations


create_superadmin


configure_permissions


final_permissions


create_version_file


install_cli


enable_firewall_port


restart_services


save_install_info


installation_complete

}


main "$@"
