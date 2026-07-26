<?php

declare(strict_types=1);

namespace App\Core;

abstract class Controller
{
    protected function view(string $view,array $data=[]):void
    {
        extract($data);

        require ROOT_PATH.'/app/Views/'.$view.'.php';
    }

    protected function redirect(string $url):void
    {
        header("Location: ".$url);

        exit;
    }

    protected function json(array $data):void
    {
        header('Content-Type: application/json');

        echo json_encode($data,JSON_PRETTY_PRINT);

        exit;
    }
}
