<?php

namespace App\Models;


use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;


class OcservServer extends Model
{


use HasFactory;



protected $fillable=[


'name',
'ip_address',
'ssh_port',
'ssh_username',
'ssh_password',
'ocserv_port',
'status',
'last_check'


];



protected $hidden=[

'ssh_password'

];



protected $casts=[


'status'=>'boolean',

'last_check'=>'datetime'


];





public function vpnUsers()
{

return $this->hasMany(
    VpnUser::class,
    'server_id'
);

}




public function onlineUsers()
{

return $this->vpnUsers()
->whereNotNull('last_login');

}


}
