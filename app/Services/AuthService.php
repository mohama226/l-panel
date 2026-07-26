<?php

declare(strict_types=1);

namespace App\Services;


use App\Repositories\AdminRepository;
use App\Core\Auth;


class AuthService
{


    public function __construct(
        private AdminRepository $admins
    )
    {}



    public function attempt(
        string $username,
        string $password
    ):bool
    {


        $admin =
        $this->admins
        ->findByUsername($username);



        if(!$admin)
        {
            return false;
        }



        if(!password_verify(
            $password,
            $admin['password']
        ))
        {
            return false;
        }



        Auth::login($admin);


        return true;

    }


}
