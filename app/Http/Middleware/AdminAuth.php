<?php

namespace App\Http\Middleware;


use Closure;

use Illuminate\Http\Request;

use Symfony\Component\HttpFoundation\Response;



class AdminAuth
{


    /**
     * Handle an incoming request.
     */


    public function handle(
        Request $request,
        Closure $next
    ): Response
    {



        /*
        |--------------------------------------------------------------------------
        | Check Admin Session
        |--------------------------------------------------------------------------
        */


        if(
            !$request->session()
            ->has('admin_id')
        )
        {


            return redirect()
            ->route(
                'admin.login'
            );


        }






        return $next($request);


    }



}
