#!/bin/bash


create_admin(){


echo ""

echo "Create Super Admin"

echo ""


read -p "Username: " ADMIN_USER


while true
do

read -s -p "Password: " ADMIN_PASS
echo ""

read -s -p "Confirm Password: " ADMIN_PASS2
echo ""


if [ "$ADMIN_PASS" = "$ADMIN_PASS2" ]
then
break
fi


echo "Passwords do not match"


done


cd /opt/l-panel


php -r "

require 'vendor/autoload.php';

require 'bootstrap/app.php';


\$db=new App\Core\Database();


\$stmt=\$db->connection()->prepare(

'INSERT INTO admins(username,password,role)
VALUES(?,?,?)'

);


\$stmt->execute([

'$ADMIN_USER',

password_hash('$ADMIN_PASS',PASSWORD_BCRYPT),

'superadmin'

]);


"


ok "SuperAdmin created"


}
