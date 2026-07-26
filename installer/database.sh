#!/bin/bash


run_migrations(){

echo ""

echo "Migration started"


cd /opt/l-panel


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
