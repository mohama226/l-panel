#!/bin/bash


echo "

Starting L-PANEL Docker

"



docker compose up -d





echo "

Installing Laravel packages

"



docker exec -it lpanel_app composer install





docker exec -it lpanel_app php artisan key:generate





docker exec -it lpanel_app php artisan migrate --seed





echo "

L-PANEL Docker Ready

"



echo "

Open:

http://SERVER-IP

"
