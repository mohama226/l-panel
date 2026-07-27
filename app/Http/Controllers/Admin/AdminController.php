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
        ->get();



        return view(
            'admin.admins',
            compact('admins')
        );


    }








    public function store(
        Request $request
    )
    {


        Admin::create([


            'name'=>
            $request->name,


            'username'=>
            $request->username,


            'password'=>
            Hash::make(
                $request->password
            ),


            'role'=>
            $request->role


        ]);



        return back();


    }


}
