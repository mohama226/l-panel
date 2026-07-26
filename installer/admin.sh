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


if [ "$ADMIN_PASS" = "$ADMIN_PASS2" ]; then
    break
fi


echo "Passwords do not match"

done


export ADMIN_USER
export ADMIN_PASS


cd /opt/l-panel || exit 1


php <<'PHP'

<?php

require "bootstrap/app.php";


$db = new App\Core\Database();


$stmt = $db->connection()->prepare(
"
INSERT INTO admins
(username,password,role)
VALUES
(?,?,?)
"
);


$stmt->execute([

getenv('ADMIN_USER'),

password_hash(
    getenv('ADMIN_PASS'),
    PASSWORD_BCRYPT
),

'superadmin'

]);


echo "Admin inserted\n";


PHP


ok "SuperAdmin created"


}
