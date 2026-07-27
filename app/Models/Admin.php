<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Admin extends Authenticatable
{
    protected $table = 'admins';

    protected $fillable = [
        'name',
        'username',
        'password',
        'role',
        'status',
        'last_login'
    ];

    protected $hidden = [
        'password'
    ];

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
}
