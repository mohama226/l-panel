<?php

namespace App\Http\Controllers\Admin;


use App\Http\Controllers\Controller;
use App\Models\Admin;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;



class AdminController extends Controller
{


public function index()
{


$admins =
Admin::latest()
->paginate(20);



return view(
'admin.admins.index',
compact('admins')
);


}





public function store(Request $request)
{


$data=$request->validate([


'name'=>'required',

'email'=>'required|email|unique:admins',

'username'=>'required|unique:admins',

'password'=>'required'


]);



$data['password']
=
Hash::make(
$data['password']
);



Admin::create($data);



return back();


}




public function destroy(
Admin $admin
)
{


$admin->delete();


return back();


}



}
