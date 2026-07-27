<?php

namespace App\Services;


use App\Models\VpnUser;

use App\Models\OcservServer;

use Illuminate\Support\Facades\Log;



class OcservService
{


    protected ServerManager $serverManager;



    public function __construct(
        ServerManager $serverManager
    )
    {

        $this->serverManager = $serverManager;

    }






    /**
     * Create OCServ User
     */


    public function createUser(
        VpnUser $user
    )
    {


        $server = $user->server;



        $command = "

        sudo ocpasswd -c /etc/ocserv/ocpasswd "

        .$user->username;



        return $this->serverManager
        ->execute(
            $server,
            $command
        );



    }








    /**
     * Delete OCServ User
     */


    public function deleteUser(
        VpnUser $user
    )
    {


        $server = $user->server;



        $command = "

        sudo ocpasswd -d "

        .$user->username;



        return $this->serverManager
        ->execute(
            $server,
            $command
        );



    }








    /**
     * Restart OCServ
     */


    public function restart(
        OcservServer $server
    )
    {


        return $this->serverManager
        ->execute(

            $server,

            'sudo systemctl restart ocserv'

        );



    }







    /**
     * Check OCServ Status
     */


    public function status(
        OcservServer $server
    )
    {



        return $this->serverManager
        ->execute(

            $server,

            'systemctl status ocserv'

        );



    }



}
