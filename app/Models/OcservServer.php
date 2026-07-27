<?php

namespace App\Models;


use Illuminate\Database\Eloquent\Model;



class OcservServer extends Model
{


    protected $fillable = [


        'name',

        'ip_address',

        'ssh_username',

        'ssh_password',

        'ssh_port',

        'status'


    ];







    protected $hidden = [


        'ssh_password'


    ];







    protected $casts = [


        'status'=>'boolean'


    ];








    public function vpnUsers()
    {


        return $this->hasMany(
            VpnUser::class,
            'server_id'
        );


    }






}
