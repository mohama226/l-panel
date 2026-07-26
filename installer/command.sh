#!/bin/bash


install_command(){


cat >/usr/local/bin/l-panel <<'EOF'

#!/bin/bash


cd /var/www/l-panel


echo "
1) Update Panel
2) Restart Services
3) Laravel Cache Clear
4) Exit
"


read -p "Select: " x


case $x in


1)

git pull

composer install

php artisan migrate

;;


2)

systemctl restart nginx
systemctl restart php-fpm

;;


3)

php artisan optimize:clear

;;


*)

exit

;;


esac


EOF


chmod +x /usr/local/bin/l-panel


}
