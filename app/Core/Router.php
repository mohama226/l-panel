<?php

declare(strict_types=1);

namespace App\Core;

class Router
{
    private array $routes = [];

    public function get(string $uri, callable|array $action): void
    {
        $this->routes['GET'][$uri] = $action;
    }

    public function post(string $uri, callable|array $action): void
    {
        $this->routes['POST'][$uri] = $action;
    }

    public function dispatch(): void
    {
        $method = $_SERVER['REQUEST_METHOD'];

        $uri = parse_url($_SERVER['REQUEST_URI'],PHP_URL_PATH);

        if(isset($this->routes[$method][$uri])){

            $action = $this->routes[$method][$uri];

            if(is_callable($action)){

                call_user_func($action);

                return;

            }

        }

        http_response_code(404);

        echo "404 Not Found";
    }
}
