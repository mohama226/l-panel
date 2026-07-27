<?php

namespace App\Http\Controllers\Admin;


use App\Http\Controllers\Controller;
use App\Models\VpnUser;
use App\Models\OcservServer;
use App\Models\Reseller;
use App\Models\Admin;



class DashboardController extends Controller
{


    public function index()
    {


        $stats = [


            'admins' =>
                Admin::count(),


            'servers' =>
                OcservServer::count(),


            'users' =>
                VpnUser::count(),


            'active_users' =>
                VpnUser::where(
                    'status',
                    true
                )->count(),


            'resellers' =>
                Reseller::count()


        ];



        return view(
            'admin.dashboard',
            compact('stats')
        );


    }


}
