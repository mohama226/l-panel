<?php

namespace App\Http\Controllers\Admin;


use App\Http\Controllers\Controller;
use App\Models\OcservServer;
use App\Services\ServerManager;
use Illuminate\Http\Request;



class ServerController extends Controller
{


protected ServerManager $manager;



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
->paginate(20);



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

'ssh_username'=>'required'


]);



OcservServer::create($data);



return redirect()
->route('servers.index');


}







public function test(
OcservServer $server
)
{


$result =
$this->manager
->testConnection($server);



return response()->json($result);


}






public function destroy(
OcservServer $server
)
{


$server->delete();



return back();


}


}
