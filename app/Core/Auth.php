<?php

declare(strict_types=1);

namespace App\Core;


class Auth
{


    public static function login(array $admin):void
    {

        Session::set(
            'admin',
            [
                'id'=>$admin['id'],
                'username'=>$admin['username'],
                'role'=>$admin['role']
            ]
        );

    }



    public static function logout():void
    {

        Session::remove('admin');

    }



    public static function check():bool
    {

        return Session::has('admin');

    }



    public static function user():?array
    {

        return Session::get('admin');

    }


}
