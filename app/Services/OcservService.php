<?php

namespace App\Services;


use App\Models\OcservServer;
use App\Models\VpnUser;
use Illuminate\Support\Facades\Log;



class OcservService
{


    /**
     * Create VPN User on OCServ
     */


    public function createUser(
        VpnUser $user
    )
    {


        $server = $user->server;



        $command = "
        ocpasswd 
        -c /etc/ocserv/ocpasswd 
        {$user->username}
        ";



        return $this->execute(
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



        $command = "

        ocpasswd 
        -d 
        -c /etc/ocserv/ocpasswd 
        {$user->username}

        ";



        return $this->execute(
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


        $command = "

        ocpasswd 
        -u
        {$user->username}

        ";



        return $this->execute(
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


        $command = "

        ocpasswd
        -l
        {$user->username}

        ";



        return $this->execute(
            $user->server,
            $command
        );


    }








    /**
     * Check OCServ Status
     */


    public function status(
        OcservServer $server
    )
    {


        return $this->execute(
            $server,
            "systemctl status ocserv"
        );


    }









    /**
     * Execute SSH Command
     */


    protected function execute(
        OcservServer $server,
        string $command
    )
    {



        try {



            $sshCommand = sprintf(

                "ssh -p %s %s@%s '%s'",


                $server->ssh_port,


                $server->ssh_username,


                $server->ip_address,


                $command


            );



            $output = shell_exec(
                $sshCommand
            );



            return [

                'success'=>true,

                'output'=>$output

            ];




        }
        catch(\Exception $e)
        {



            Log::error(
                $e->getMessage()
            );



            return [

                'success'=>false,

                'output'=>$e->getMessage()

            ];



        }



    }



}
