<?php

namespace App\Services;


use App\Models\OcservServer;



class BackupService
{





    protected ServerManager $manager;




    public function __construct(
        ServerManager $manager
    )
    {

        $this->manager = $manager;

    }







    /**
     * Backup OCServ Config
     */


    public function backup(
        OcservServer $server
    )
    {



        $file =

        '/tmp/ocserv_backup_'

        .date('Y_m_d_H_i_s')

        .'.tar.gz';







        $command =

        "tar -czf "

        .$file.

        " /etc/ocserv";







        return $this->manager
        ->execute(

            $server,

            $command

        );



    }







    /**
     * Restore Backup
     */


    public function restore(
        OcservServer $server,

        string $file

    )
    {



        $command =

        "tar -xzf "

        .$file.

        " -C /";






        return $this->manager
        ->execute(

            $server,

            $command

        );



    }




}
