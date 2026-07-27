<?php

namespace App\Services;


use App\Models\OcservServer;



class ServerManager
{



    /**
     * Test Server Connection
     */


    public function testConnection(
        OcservServer $server
    )
    {


        $command = sprintf(

            "ssh -p %s %s@%s 'echo OK'",


            $server->ssh_port,


            $server->ssh_username,


            $server->ip_address


        );



        $result = shell_exec(
            $command
        );



        return trim($result) === "OK";


    }







    /**
     * Server Information
     */


    public function information(
        OcservServer $server
    )
    {



        $command = "

        uname -a &&
        systemctl is-active ocserv &&
        uptime

        ";



        return shell_exec(

            sprintf(

            "ssh -p %s %s@%s '%s'",


            $server->ssh_port,


            $server->ssh_username,


            $server->ip_address,


            $command

            )

        );


    }







    /**
     * Restart OCServ
     */


    public function restart(
        OcservServer $server
    )
    {



        return shell_exec(

            sprintf(

            "ssh -p %s %s@%s 'systemctl restart ocserv'",


            $server->ssh_port,


            $server->ssh_username,


            $server->ip_address


            )

        );



    }



}
