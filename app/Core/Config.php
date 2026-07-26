<?php

declare(strict_types=1);

namespace App\Core;

class Config
{
    public static function get(string $file,string $key,mixed $default=null):mixed
    {
        $config=require ROOT_PATH."/config/".$file.".php";

        return $config[$key]??$default;
    }
}
