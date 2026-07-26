<?php

use App\Core\App;

App::$router->get('/',function(){

    echo "L-Panel Home";

});

App::$router->get('/login',function(){

    echo "Login Page";

});
