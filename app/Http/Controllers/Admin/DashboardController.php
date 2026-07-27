<?php

namespace App\Http\Controllers\Admin;


use App\Http\Controllers\Controller;

use App\Models\Admin;
use App\Models\VpnUser;
use App\Models\OcservServer;
use App\Models\Reseller;



class DashboardController extends Controller
{


    public function index()
    {


        $stats = [


            'admins' =>
            Admin::count(),


            'users' =>
            VpnUser::count(),


            'servers' =>
            OcservServer::count(),


            'resellers' =>
            Reseller::count(),



            'active_users' =>
            VpnUser::where(
                'status',
                true
            )->count()


        ];



        return view(
            'admin.dashboard',
            compact('stats')
        );


    }


}
