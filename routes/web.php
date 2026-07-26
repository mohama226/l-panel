<?php

use App\Core\App;

use App\Controllers\AuthController;
use App\Controllers\DashboardController;

use App\Middleware\AuthMiddleware;
use App\Middleware\GuestMiddleware;



App::$router->get(
'/login',
[
AuthController::class,
'login'
]
);


App::$router->post(
'/login',
[
AuthController::class,
'authenticate'
]
);



App::$router->get(
'/logout',
[
AuthController::class,
'logout'
]
);



App::$router->get(
'/dashboard',
function(){

AuthMiddleware::handle();

(new DashboardController())
->index();

}
);
