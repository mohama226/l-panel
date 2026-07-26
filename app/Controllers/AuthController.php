<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;

class AuthController extends Controller
{
    public function login(): void
    {
        $this->view('auth/login');
    }

    public function authenticate(): void
    {
        echo "Processing Login";
    }

    public function logout(): void
    {
        echo "Logout";
    }
}
