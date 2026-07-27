<?php

namespace App\Http\Controllers\Auth;


use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;



class LoginController extends Controller
{


    /**
     * Show Login Page
     */

    public function showLogin()
    {

        return view('admin.login');

    }





    /**
     * Login Admin
     */

    public function login(Request $request)
    {


        $credentials = $request->validate([


            'username' => [
                'required'
            ],


            'password' => [
                'required'
            ]


        ]);





        if(
            Auth::guard('admin')
            ->attempt($credentials)
        )
        {


            $request->session()
            ->regenerate();



            $admin =
            Auth::guard('admin')
            ->user();




            $admin->update([

                'last_login'=>now()

            ]);




            return redirect()
            ->route(
                'admin.dashboard'
            );


        }





        return back()
        ->withErrors([

            'username'=>
            'اطلاعات ورود صحیح نیست'

        ]);



    }


}
