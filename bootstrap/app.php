<?php

declare(strict_types=1);

/*
|--------------------------------------------------------------------------
| Base Paths
|--------------------------------------------------------------------------
*/

define('ROOT_PATH', dirname(__DIR__));
define('APP_PATH', ROOT_PATH . '/app');
define('CONFIG_PATH', ROOT_PATH . '/config');
define('STORAGE_PATH', ROOT_PATH . '/storage');

/*
|--------------------------------------------------------------------------
| Composer Autoload
|--------------------------------------------------------------------------
*/

require ROOT_PATH . '/vendor/autoload.php';

/*
|--------------------------------------------------------------------------
| Session & Timezone
|--------------------------------------------------------------------------
*/

session_start();
date_default_timezone_set('UTC');

/*
|--------------------------------------------------------------------------
| Dependency Container
|--------------------------------------------------------------------------
*/

use App\Core\Container;
use App\Core\Database;

$container = new Container();
$GLOBALS['container'] = $container;

/*
|--------------------------------------------------------------------------
| Register Database in Container
|--------------------------------------------------------------------------
*/

$GLOBALS['container']->set(
    Database::class,
    new Database()
);
