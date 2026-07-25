<?php

namespace App\Controllers;

class AuthController
{
    public function login()
    {
        require APP_PATH . '/Views/auth/login.php';
    }

    public function authenticate()
    {

    }

    public function logout()
    {

    }
}
