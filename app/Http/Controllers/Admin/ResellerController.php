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
->paginate(20);



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
'reseller'
)
->get();



return view(
'resellers.create',
compact('admins')
);


}





public function store(Request $request)
{


$data=$request->validate([


'admin_id'=>'required',

'user_limit'=>'integer',

'server_limit'=>'integer'


]);



Reseller::create($data);



return redirect()
->route('resellers.index');


}





public function destroy(
Reseller $reseller
)
{


$reseller->delete();



return back();


}


}
