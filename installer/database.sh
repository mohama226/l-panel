#!/bin/bash

create_database(){

    systemctl enable mariadb --now

    echo "Database Configuration"

    read -p "Database Name [lpanel]: " DB_NAME < /dev/tty
    DB_NAME=${DB_NAME:-lpanel}

    read -p "Database User [lpanel]: " DB_USER < /dev/tty
    DB_USER=${DB_USER:-lpanel}

    read -s -p "Database Password (leave empty for auto): " DB_PASS < /dev/tty
    echo ""

    if [ -z "$DB_PASS" ]; then
        DB_PASS=$(openssl rand -hex 16)
        echo "Generated Database Password: $DB_PASS"
    fi

    MYSQL_ROOT_PASSWORD=""

    mysql -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"

    ok "Database created"
}

create_env(){

cat > /opt/l-panel/.env <<EOF
APP_NAME=L-Panel
APP_ENV=production
APP_DEBUG=false

APP_URL=http://127.0.0.1

DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=${DB_NAME}
DB_USERNAME=${DB_USER}
DB_PASSWORD=${DB_PASS}

TIMEZONE=UTC
EOF

ok ".env created"
}

run_migrations(){

cd /opt/l-panel

php -r '

require "bootstrap/app.php";

$migrator = new App\Core\Migrator();

$migrator->run();

'

ok "Database migrations completed"

}
