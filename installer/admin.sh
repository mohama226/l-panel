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


php artisan tinker --execute="
\App\Models\User::create([
'name'=>'$ADMIN_USER',
'email'=>'$ADMIN_USER@example.com',
'password'=>bcrypt('$ADMIN_PASS'),
]);
"


echo "[OK] Super Admin created"

}
