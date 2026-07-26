#!/bin/bash


install_laravel(){


echo "[OK] Installing Laravel"


mkdir -p /opt


if [ ! -d /opt/l-panel ]; then


composer create-project laravel/laravel /opt/l-panel


else

echo "Laravel already exists"

fi


cd /opt/l-panel


php artisan key:generate --force


}
