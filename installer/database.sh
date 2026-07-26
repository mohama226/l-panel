#!/bin/bash


setup_database(){

cd /opt/l-panel


php artisan migrate --force


}
