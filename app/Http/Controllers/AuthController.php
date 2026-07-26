<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{

    public function show()
    {
        return view('auth.login');
    }


    public function login(Request $request)
    {

        $data = $request->validate([
            'username'=>'required',
            'password'=>'required'
        ]);


        if(Auth::guard('admin')->attempt([
            'username'=>$data['username'],
            'password'=>$data['password'],
            'status'=>1
        ]))
        {

            $request->session()->regenerate();

            return redirect('/dashboard');

        }


        return back()->withErrors([
            'username'=>'نام کاربری یا رمز عبور اشتباه است'
        ]);

    }



    public function logout(Request $request)
    {

        Auth::guard('admin')->logout();

        $request->session()->invalidate();

        return redirect('/login');

    }

}
