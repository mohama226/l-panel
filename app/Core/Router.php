<?php

class Router
{
    public static function run()
    {
        $uri = explode('?', $_SERVER['REQUEST_URI'])[0];

        if ($uri === '/auth/login' && $_SERVER['REQUEST_METHOD'] === 'POST') {
            require_once __DIR__ . '/../Controllers/AuthController.php';
            (new AuthController())->login();
            return;
        }

        if ($uri === '/auth/logout') {
            require_once __DIR__ . '/../Controllers/AuthController.php';
            (new AuthController())->logout();
            return;
        }

        if ($uri === '/dashboard') {
            require_once __DIR__ . '/../Controllers/DashboardController.php';
            (new DashboardController())->index();
            return;
        }

        require_once __DIR__ . '/../../public/login.php';
    }
}
