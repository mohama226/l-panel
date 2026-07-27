<?php

namespace App\Models;


use Illuminate\Database\Eloquent\Model;



class Subscription extends Model
{


    protected $fillable = [


        'vpn_user_id',

        'plan',

        'start_date',

        'end_date',

        'price',

        'status'


    ];







    protected $casts = [


        'start_date'=>'date',

        'end_date'=>'date',

        'status'=>'boolean'


    ];







    public function vpnUser()
    {


        return $this->belongsTo(
            VpnUser::class
        );


    }



}
