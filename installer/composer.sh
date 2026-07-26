#!/bin/bash


install_composer(){


if command -v composer >/dev/null
then

success "Composer exists"

else


curl -sS https://getcomposer.org/installer | php

mv composer.phar /usr/local/bin/composer


fi


composer -V


}
