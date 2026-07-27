<?php

namespace App\Models;


use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;


class Subscription extends Model
{


use HasFactory;



protected $fillable=[


'vpn_user_id',
'start_date',
'end_date',
'traffic_limit',
'plan_name',
'active'


];



protected $casts=[


'start_date'=>'date',

'end_date'=>'date',

'active'=>'boolean'


];





public function vpnUser()
{

return $this->belongsTo(
    VpnUser::class
);

}



public function isActive()
{

return $this->active &&
       now()->between(
           $this->start_date,
           $this->end_date
       );

}


}
