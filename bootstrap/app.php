<?php

declare(strict_types=1);

define('ROOT_PATH', dirname(__DIR__));

define('APP_PATH', ROOT_PATH.'/app');

define('CONFIG_PATH', ROOT_PATH.'/config');

define('STORAGE_PATH', ROOT_PATH.'/storage');


require ROOT_PATH.'/vendor/autoload.php';


use Dotenv\Dotenv;


if(file_exists(ROOT_PATH.'/.env')){

    $dotenv = Dotenv::createImmutable(ROOT_PATH);

    $dotenv->load();

}


date_default_timezone_set(
    $_ENV['TIMEZONE'] ?? 'UTC'
);


session_start();


use App\Core\Container;


$container=new Container();


$GLOBALS['container']=$container;
