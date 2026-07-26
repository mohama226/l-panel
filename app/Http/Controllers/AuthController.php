<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;


class AuthController extends Controller
{


public function show()
{
    return view('auth.login');
}



public function login(Request $request)
{

$admin = DB::table('admins')
->where('username',$request->username)
->first();


if($admin && Hash::check($request->password,$admin->password))
{

session([
'admin_id'=>$admin->id,
'admin_role'=>$admin->role
]);


return redirect('/dashboard');

}


return back()->with('error','Login failed');

}



public function logout()
{

session()->flush();

return redirect('/login');

}


}
