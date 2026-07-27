<?php

namespace App\Services;


use App\Models\OcservServer;
use Illuminate\Support\Facades\Log;



class ServerManager
{



    /**
     * Execute command on server
     */


    public function execute(
        OcservServer $server,
        string $command
    )
    {


        try {


            $ssh = sprintf(

            "ssh -p %s %s@%s '%s'",


            $server->ssh_port,

            $server->ssh_username,

            $server->ip_address,

            $command


            );



            $result = shell_exec($ssh);



            return [

                'success'=>true,

                'output'=>$result

            ];



        }
        catch(\Exception $e)
        {


            Log::error(
                $e->getMessage()
            );


            return [

                'success'=>false,

                'error'=>$e->getMessage()

            ];

        }



    }





    /**
     * Test Server Connection
     */


    public function testConnection(
        OcservServer $server
    )
    {


        return $this->execute(

            $server,

            "echo connected"

        );


    }





    /**
     * Server Ping
     */


    public function ping(
        OcservServer $server
    )
    {


        $command = "ping -c 2 ".$server->ip_address;


        exec(
            $command,
            $output,
            $status
        );



        return $status === 0;


    }



}
