<?php

namespace App\Models;


use Illuminate\Database\Eloquent\Model;



class Reseller extends Model
{


    protected $fillable = [


        'admin_id',

        'user_limit',

        'server_limit',

        'balance',

        'status'


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
