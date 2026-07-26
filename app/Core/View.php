<?php

declare(strict_types=1);

namespace App\Core;

class View
{
    public static function render(string $view,array $data=[]): void
    {
        extract($data);

        require ROOT_PATH."/app/Views/{$view}.php";
    }
}
