<?php

declare(strict_types=1);

namespace App\Core;

class Router
{
    private array $routes=[];

    public function get(string $uri,array|callable $action): void
    {
        $this->routes['GET'][$uri]=$action;
    }

    public function post(string $uri,array|callable $action): void
    {
        $this->routes['POST'][$uri]=$action;
    }

    public function dispatch(): void
    {
        $request=new Request();

        $method=$request->method();

        $uri=$request->uri();

        if(!isset($this->routes[$method][$uri])){

            Response::abort();

        }

        $action=$this->routes[$method][$uri];

        if(is_callable($action)){

            call_user_func($action);

            return;

        }

        [$controller,$function]=$action;

        (new $controller)->$function();
    }
}
