<?php

$router->get('/login', 'AuthController@login');
$router->post('/login', 'AuthController@authenticate');
$router->get('/logout', 'AuthController@logout');
