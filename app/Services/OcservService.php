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
     * Create VPN User on OCServ
     */

    public function createUser(
        VpnUser $user
    )
    {


        $server = $user->server;


        $command = sprintf(

            "sudo ocpasswd -c /etc/ocserv/ocpasswd %s",

            escapeshellarg(
                $user->username
            )

        );



        return $this->serverManager
            ->execute(
                $server,
                $command
            );


    }





    /**
     * Delete VPN User
     */


    public function deleteUser(
        VpnUser $user
    )
    {


        $server = $user->server;


        $command = sprintf(

            "sudo ocpasswd -d -c /etc/ocserv/ocpasswd %s",

            escapeshellarg(
                $user->username
            )

        );



        return $this->serverManager
            ->execute(
                $server,
                $command
            );


    }





    /**
     * Enable User
     */


    public function enableUser(
        VpnUser $user
    )
    {


        $command = sprintf(

            "sudo ocpasswd -u -c /etc/ocserv/ocpasswd %s",

            escapeshellarg(
                $user->username
            )

        );


        return $this->serverManager
            ->execute(
                $user->server,
                $command
            );


    }





    /**
     * Disable User
     */


    public function disableUser(
        VpnUser $user
    )
    {


        $command = sprintf(

            "sudo ocpasswd -l -c /etc/ocserv/ocpasswd %s",

            escapeshellarg(
                $user->username
            )

        );


        return $this->serverManager
            ->execute(
                $user->server,
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
                "sudo systemctl restart ocserv"
            );


    }





    /**
     * Check Status
     */


    public function status(
        OcservServer $server
    )
    {


        return $this->serverManager
            ->execute(

                $server,

                "systemctl status ocserv"

            );


    }



}
