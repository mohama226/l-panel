<?php

declare(strict_types=1);

require dirname(__DIR__).'/bootstrap/app.php';

use App\Core\App;

App::boot();

require ROOT_PATH.'/routes/web.php';

App::run();
