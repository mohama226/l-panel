<?php

namespace App\Models;


use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;


class VpnUser extends Model
{


use HasFactory;



protected $fillable=[


'server_id',
'created_by',
'reseller_id',
'username',
'password',
'expire_date',
'traffic_limit',
'traffic_used',
'device_limit',
'status',
'last_login',
'last_ip'


];



protected $hidden=[

'password'

];



protected $casts=[


'expire_date'=>'date',

'status'=>'boolean',

'last_login'=>'datetime'


];




public function server()
{

return $this->belongsTo(
    OcservServer::class,
    'server_id'
);

}



public function creator()
{

return $this->belongsTo(
    Admin::class,
    'created_by'
);

}



public function reseller()
{

return $this->belongsTo(
    Reseller::class
);

}



public function subscriptions()
{

return $this->hasMany(
    Subscription::class
);

}



/*
|--------------------------------------------------------------------------
| Status Helpers
|--------------------------------------------------------------------------
*/


public function isExpired()
{

return now()
->greaterThan($this->expire_date);

}



public function remainingTraffic()
{

return $this->traffic_limit 
       - $this->traffic_used;

}


}
