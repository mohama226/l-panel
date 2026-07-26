#!/bin/bash

create_database(){

echo "[OK] Database migration"

cd /opt/l-panel || exit 1

php artisan migrate --force

if [ $? -eq 0 ]; then
    echo "[OK] Database ready"
else
    echo "[ERROR] Migration failed"
    exit 1
fi

}
