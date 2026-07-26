#!/bin/bash


create_database(){


echo ""

echo "Database Configuration"


read -p "Database Name [lpanel]: " DB_NAME

DB_NAME=${DB_NAME:-lpanel}


read -p "Database User [lpanel]: " DB_USER

DB_USER=${DB_USER:-lpanel}


read -s -p "Database Password (leave empty for auto): " DB_PASS

echo ""


if [ -z "$DB_PASS" ]

then

DB_PASS=$(openssl rand -hex 12)

fi


mysql <<MYSQL

CREATE DATABASE IF NOT EXISTS $DB_NAME
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;


CREATE USER IF NOT EXISTS '$DB_USER'@'localhost'
IDENTIFIED BY '$DB_PASS';


ALTER USER '$DB_USER'@'localhost'
IDENTIFIED BY '$DB_PASS';


GRANT ALL PRIVILEGES ON $DB_NAME.*
TO '$DB_USER'@'localhost';


FLUSH PRIVILEGES;

MYSQL


export DB_NAME
export DB_USER
export DB_PASS


ok "Database created"

}



run_migrations(){


echo ""

echo "Migration started"


cd /opt/l-panel || exit 1


php -r '

require "vendor/autoload.php";

require "bootstrap/app.php";


$migrator = new App\Core\Migrator();

$migrator->run();

'


if [ $? -eq 0 ]

then

ok "Database migrations completed"

else

error "Migration failed"

fi


}
