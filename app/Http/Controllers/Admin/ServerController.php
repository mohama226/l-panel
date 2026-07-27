<?php

namespace App\Http\Controllers\Admin;


use App\Http\Controllers\Controller;


use App\Models\OcservServer;


use App\Services\ServerManager;


use Illuminate\Http\Request;



class ServerController extends Controller
{


    protected $manager;



    public function __construct(
        ServerManager $manager
    )
    {

        $this->manager=$manager;

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








    public function store(
        Request $request
    )
    {


        OcservServer::create(

            $request->validate([


                'name'=>
                'required',


                'ip_address'=>
                'required',


                'ssh_username'=>
                'required'


            ])

        );



        return redirect()
        ->route(
            'servers.index'
        );


    }








    public function test(
        OcservServer $server
    )
    {


        return response()->json([

            'status'=>
            $this->manager
            ->testConnection($server)

        ]);


    }








    public function restart(
        OcservServer $server
    )
    {


        return $this->manager
        ->restart($server);


    }



}
