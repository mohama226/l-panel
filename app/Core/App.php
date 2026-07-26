<?php

declare(strict_types=1);

namespace App\Core;

class App
{
    public static Router $router;

    public static function boot(): void
    {
        self::$router = new Router();
    }

    public static function run(): void
    {
        self::$router->dispatch();
    }
}
