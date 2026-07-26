#!/bin/bash


install_php(){

echo "[OK] Installing PHP"


if [ "$OS" = "almalinux" ]; then

dnf install -y php php-cli php-fpm php-mysqlnd php-mbstring php-xml php-bcmath php-curl php-zip

systemctl enable php-fpm
systemctl restart php-fpm


else

apt install -y php php-cli php-fpm php-mysql php-mbstring php-xml php-bcmath php-curl php-zip

systemctl enable php8.3-fpm
systemctl restart php8.3-fpm

fi


}
