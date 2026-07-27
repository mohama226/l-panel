<?php

namespace App\Models;


use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Notifications\Notifiable;


class Admin extends Authenticatable
{

use HasFactory, Notifiable;


protected $fillable = [

'name',
'email',
'username',
'password',
'role',
'status',
'last_login'

];


protected $hidden = [

'password',
'remember_token'

];


protected $casts = [

'status'=>'boolean',
'last_login'=>'datetime'

];



/*
|--------------------------------------------------------------------------
| Relations
|--------------------------------------------------------------------------
*/


public function reseller()
{

return $this->hasOne(
    Reseller::class
);

}



public function vpnUsers()
{

return $this->hasMany(
    VpnUser::class,
    'created_by'
);

}



public function logs()
{

return $this->hasMany(
    ActivityLog::class
);

}




/*
|--------------------------------------------------------------------------
| Helpers
|--------------------------------------------------------------------------
*/


public function isSuperAdmin()
{

return $this->role === 'superadmin';

}



public function isAdmin()
{

return $this->role === 'admin';

}



public function isReseller()
{

return $this->role === 'reseller';

}


}
