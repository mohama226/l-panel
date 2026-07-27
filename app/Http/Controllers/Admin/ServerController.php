<?php

namespace App\Http\Controllers\Admin;


use App\Http\Controllers\Controller;


use App\Models\OcservServer;


use App\Services\ServerManager;

use App\Services\OcservService;


use Illuminate\Http\Request;



class ServerController extends Controller
{


    protected ServerManager $manager;


    protected OcservService $ocserv;




    public function __construct(
        ServerManager $manager,
        OcservService $ocserv
    )
    {


        $this->manager=$manager;

        $this->ocserv=$ocserv;


    }






    public function index()
    {


        $servers =
        OcservServer::latest()
        ->get();



        return view(

            'servers.index',

            compact('servers')

        );


    }







    public function create()
    {


        return view(
            'servers.create'
        );


    }







    public function store(Request $request)
    {



        $data=$request->validate([


            'name'=>'required',


            'ip_address'=>'required',


            'ssh_username'=>'required',


            'ssh_port'=>'required'


        ]);




        OcservServer::create($data);




        return redirect()
        ->route('servers.index');



    }







    public function test(
        OcservServer $server
    )
    {


        return $this->manager
        ->test($server);


    }







    public function restart(
        OcservServer $server
    )
    {


        return $this->ocserv
        ->restart($server);


    }



}
