<?php

namespace App\Models;


use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;


class Reseller extends Model
{


use HasFactory;



protected $fillable=[


'admin_id',
'user_limit',
'server_limit',
'balance',
'status'


];



protected $casts=[

'balance'=>'decimal:2',

'status'=>'boolean'

];



public function admin()
{

return $this->belongsTo(
    Admin::class
);

}



public function vpnUsers()
{

return $this->hasMany(
    VpnUser::class
);

}


}
