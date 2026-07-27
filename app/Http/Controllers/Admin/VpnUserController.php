<?php

namespace App\Http\Controllers\Admin;


use App\Http\Controllers\Controller;
use App\Models\VpnUser;
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


$users =
VpnUser::with([
'server',
'reseller'
])
->latest()
->paginate(50);



return view(
'vpn-users.index',
compact('users')
);


}





public function create()
{

return view(
'vpn-users.create'
);

}





public function store(Request $request)
{


$data=$request->validate([


'username'=>'required|unique:vpn_users',

'password'=>'required',

'server_id'=>'required',

'expire_date'=>'nullable|date'


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


$this->ocserv
->enableUser($vpnUser);



$vpnUser->update([

'status'=>true

]);



return back();


}





public function disable(
VpnUser $vpnUser
)
{


$this->ocserv
->disableUser($vpnUser);



$vpnUser->update([

'status'=>false

]);



return back();


}


}
