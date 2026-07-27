<?php

namespace App\Http\Middleware;


use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;



class AdminAuthenticate
{


    /**
     * Handle an incoming request.
     */

    public function handle(
        Request $request,
        Closure $next
    ): Response
    {


        if(!Auth::guard('admin')->check())
        {


            return redirect()
                ->route('admin.login');


        }



        $admin =
        Auth::guard('admin')->user();



        if(!$admin->status)
        {


            Auth::guard('admin')
                ->logout();



            return redirect()
                ->route('admin.login')
                ->with(
                    'error',
                    'Account disabled'
                );


        }



        return $next($request);


    }


}
