<?php

namespace App\Services;


use App\Models\OcservServer;


use phpseclib3\Net\SSH2;




class ServerManager
{





    /**
     * Connect SSH
     */


    public function connect(
        OcservServer $server
    )
    {



        $ssh = new SSH2(

            $server->ip_address,

            $server->ssh_port

        );






        if(
            !$ssh->login(

                $server->ssh_username,

                $server->ssh_password

            )
        )
        {


            throw new \Exception(

                'SSH connection failed'

            );


        }




        return $ssh;



    }







    /**
     * Execute Command
     */


    public function execute(

        OcservServer $server,

        string $command

    )
    {



        $ssh = $this->connect(
            $server
        );




        return $ssh->exec(
            $command
        );



    }







    /**
     * Test Server
     */


    public function test(
        OcservServer $server
    )
    {



        try {


            $ssh =
            $this->connect(
                $server
            );



            return [

                'status'=>true,

                'message'=>'Connected'

            ];



        }
        catch(\Exception $e)
        {



            return [

                'status'=>false,

                'message'=>$e->getMessage()

            ];



        }



    }





}
