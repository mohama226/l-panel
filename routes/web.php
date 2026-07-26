<?php

use App\Core\App;
use App\Controllers\AuthController;

App::$router->get('/',[
    AuthController::class,
    'login'
]);

App::$router->get('/login',[
    AuthController::class,
    'login'
]);

App::$router->post('/login',[
    AuthController::class,
    'authenticate'
]);

App::$router->get('/logout',[
    AuthController::class,
    'logout'
]);
