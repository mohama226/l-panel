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
|
| اگر autoload در composer.json نبود، باید اضافه شود:
|
| {
|   "autoload": {
|     "psr-4": {
|       "App\\": "app/"
|     }
|   }
| }
|
| سپس:
| composer dump-autoload
|
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

$container = new Container();
$GLOBALS['container'] = $container;
