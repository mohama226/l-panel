<?php

namespace App\Http\Middleware;


use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;



class PermissionMiddleware
{


    public function handle(
        Request $request,
        Closure $next,
        ...$roles
    ): Response
    {


        $admin =
        Auth::guard('admin')->user();



        if(!$admin)
        {


            return redirect()
                ->route('admin.login');


        }





        if(
            !in_array(
                $admin->role,
                $roles
            )
        )
        {


            abort(
                403,
                'Access denied'
            );


        }




        return $next($request);


    }


}
