<?php

declare(strict_types=1);

namespace App\Core;

abstract class Controller
{
    protected Request $request;

    public function __construct()
    {
        $this->request=new Request();
    }

    protected function view(string $view,array $data=[]): void
    {
        View::render($view,$data);
    }

    protected function redirect(string $url): never
    {
        Response::redirect($url);
    }

    protected function json(array $data): never
    {
        Response::json($data);
    }
}
