#!/bin/bash


create_command(){

cat >/usr/local/bin/l-panel <<'EOF'

#!/bin/bash

cd /opt/l-panel

echo "
1) Update
2) Restart nginx
3) Restart php
4) Laravel migrate
"


read -p "Select: " c


case $c in

1)
git pull
composer install
php artisan migrate --force
;;

2)
systemctl restart nginx
;;

3)
systemctl restart php-fpm
;;

4)
php artisan migrate --force
;;

esac

EOF


chmod +x /usr/local/bin/l-panel


echo "[OK] l-panel command created"

}
