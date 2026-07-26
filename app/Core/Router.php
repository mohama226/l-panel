public function dispatch():void
{
    $method=$_SERVER['REQUEST_METHOD'];

    $uri=parse_url($_SERVER['REQUEST_URI'],PHP_URL_PATH);

    if(!isset($this->routes[$method][$uri])){

        http_response_code(404);

        echo "404";

        return;

    }

    $action=$this->routes[$method][$uri];

    if(is_callable($action)){

        call_user_func($action);

        return;

    }

    if(is_array($action)){

        [$controller,$function]=$action;

        (new $controller)->$function();

        return;

    }

}
