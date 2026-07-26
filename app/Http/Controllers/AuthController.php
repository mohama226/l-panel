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

        $request->validate([
            'username' => 'required',
            'password' => 'required',
        ]);


        $login = $request->username;


        $field = filter_var($login, FILTER_VALIDATE_EMAIL)
            ? 'email'
            : 'name';


        if(Auth::attempt([
            $field => $login,
            'password' => $request->password
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

        Auth::logout();

        $request->session()->invalidate();

        $request->session()->regenerateToken();


        return redirect('/login');

    }

}
