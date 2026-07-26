<?php

declare(strict_types=1);

namespace App\Controllers;


use App\Core\Controller;
use App\Core\CSRF;
use App\Core\Response;
use App\Core\Auth;



class AuthController extends Controller
{


    public function login():void
    {

        $this->view('auth/login',
        [
            'csrf'=>CSRF::token()
        ]);

    }



    public function authenticate():void
    {

        if(!CSRF::verify(
            $_POST['_token'] ?? ''
        ))
        {

            Response::abort(403);

        }


        echo "LOGIN PROCESS";

    }



    public function logout():void
    {

        Auth::logout();

        Response::redirect('/login');

    }


}
