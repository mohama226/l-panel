<?php

namespace App\Http\Controllers\Admin;


use App\Http\Controllers\Controller;


use App\Models\VpnUser;

use App\Models\OcservServer;


use App\Services\OcservService;


use Illuminate\Http\Request;



class VpnUserController extends Controller
{


    protected OcservService $ocserv;




    public function __construct(
        OcservService $ocserv
    )
    {

        $this->ocserv=$ocserv;

    }





    public function index()
    {



        $users = VpnUser::with('server')
        ->latest()
        ->get();



        return view(

            'vpn-users.index',

            compact('users')

        );


    }







    public function create()
    {


        $servers =
        OcservServer::where(
            'status',
            true
        )->get();




        return view(

            'vpn-users.create',

            compact('servers')

        );


    }







    public function store(Request $request)
    {



        $data=$request->validate([


            'username'=>'required|unique:vpn_users',


            'password'=>'required',


            'server_id'=>'required',


            'expire_date'=>'required|date'


        ]);




        $user=VpnUser::create($data);




        $this->ocserv
        ->createUser($user);




        return redirect()
        ->route('vpn-users.index');



    }







    public function destroy(
        VpnUser $vpnUser
    )
    {


        $this->ocserv
        ->deleteUser($vpnUser);



        $vpnUser->delete();




        return back();



    }








    public function enable(
        VpnUser $vpnUser
    )
    {


        $vpnUser->update([

            'status'=>true

        ]);



        return back();


    }







    public function disable(
        VpnUser $vpnUser
    )
    {


        $vpnUser->update([

            'status'=>false

        ]);



        return back();


    }



}
