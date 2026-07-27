<?php

namespace App\Http\Controllers\Admin;


use App\Http\Controllers\Controller;


use App\Models\Reseller;
use App\Models\Admin;


use Illuminate\Http\Request;



class ResellerController extends Controller
{


    public function index()
    {


        $resellers =
        Reseller::with('admin')
        ->get();



        return view(
            'resellers.index',
            compact('resellers')
        );


    }








    public function create()
    {


        $admins =
        Admin::where(
            'role',
            'admin'
        )->get();



        return view(
            'resellers.create',
            compact('admins')
        );


    }








    public function store(
        Request $request
    )
    {


        Reseller::create(

            $request->validate([


                'admin_id'=>
                'required',


                'user_limit'=>
                'required|integer',


                'server_limit'=>
                'required|integer'


            ])

        );



        return redirect()
        ->route(
            'resellers.index'
        );


    }


}
