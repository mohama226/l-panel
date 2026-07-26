#!/bin/bash


create_admin(){


cd /var/www/l-panel


read -p "Super Admin username: " ADMIN


read -s -p "Password: " PASS

echo ""


php artisan tinker --execute="

\App\Models\User::create([

'name'=>'$ADMIN',

'email'=>'$ADMIN@admin.local',

'password'=>bcrypt('$PASS')

]);

"


success "Admin created"


}
