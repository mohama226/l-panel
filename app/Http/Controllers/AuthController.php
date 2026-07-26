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
            'username'=>'required',
            'password'=>'required'
        ]);


        if(Auth::attempt([
            'name'=>$credentials['username'],
            'password'=>$credentials['password']
        ])){

            $request->session()->regenerate();

            return redirect('/dashboard');

        }


        return back()->withErrors([
            'username'=>'Login failed'
        ]);

    }


    public function logout(Request $request)
    {
        Auth::logout();

        $request->session()->invalidate();

        return redirect('/login');
    }
}
