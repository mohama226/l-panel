<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{

    public function login()
    {
        return view('login');
    }


    public function authenticate(Request $request)
    {

        $credentials = $request->validate([
            'email'=>'required',
            'password'=>'required'
        ]);


        if(Auth::attempt($credentials)){

            $request->session()->regenerate();

            return redirect('/dashboard');
        }


        return back()->withErrors([
            'email'=>'Invalid login'
        ]);

    }


    public function logout(Request $request)
    {

        Auth::logout();

        $request->session()->invalidate();

        return redirect('/login');

    }

}
