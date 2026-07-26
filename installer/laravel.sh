#!/bin/bash

install_laravel(){

echo "[OK] Installing Laravel"


if [ -d "/opt/l-panel" ]; then

    echo "[OK] Existing Laravel directory found"

else

    composer create-project \
    laravel/laravel \
    /opt/l-panel

fi


cd /opt/l-panel


if [ ! -f ".env" ]; then

cp .env.example .env

fi


php artisan key:generate


chmod -R 775 storage bootstrap/cache


echo "[OK] Laravel installed"

}
