<?php

namespace App\Models;


use Illuminate\Database\Eloquent\Model;



class VpnUser extends Model
{


    protected $fillable = [


        'username',

        'password',

        'server_id',

        'reseller_id',

        'created_by',

        'expire_date',

        'status'


    ];





    protected $casts = [


        'expire_date'=>'date',

        'status'=>'boolean'


    ];








    public function server()
    {


        return $this->belongsTo(
            OcservServer::class,
            'server_id'
        );


    }







    public function reseller()
    {


        return $this->belongsTo(
            Reseller::class
        );


    }








    public function creator()
    {


        return $this->belongsTo(
            Admin::class,
            'created_by'
        );


    }





}
