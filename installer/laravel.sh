#!/bin/bash


install_laravel(){


mkdir -p /var/www


cd /var/www


composer create-project laravel/laravel l-panel


cd /var/www/l-panel


cp .env.example .env


php artisan key:generate


DB=$(cat /tmp/lpanel_db)


sed -i "s/DB_DATABASE=.*/DB_DATABASE=$DB/" .env


php artisan migrate


success "Laravel installed"


}
