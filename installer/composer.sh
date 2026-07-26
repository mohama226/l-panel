#!/bin/bash


install_composer(){


if command -v composer >/dev/null 2>&1

then

ok "Composer already installed"

composer --version

else


php -r "copy('https://getcomposer.org/installer','composer-setup.php');"

php composer-setup.php --install-dir=/usr/local/bin --filename=composer

rm composer-setup.php


ok "Composer installed"


fi


}



install_dependencies(){


cd /opt/l-panel || exit 1


echo "Installing L-Panel dependencies..."


composer install --no-interaction --prefer-dist


if [ $? -eq 0 ]

then

ok "Composer dependencies installed"

else

error "Composer install failed"

fi


}
