<?php

namespace App\Http\Middleware;

use Closure;


class AdminAuth
{


public function handle($request,Closure $next)
{


if(!session('admin_id'))
{
return redirect('/login');
}


return $next($request);


}



}
