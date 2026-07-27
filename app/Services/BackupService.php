<?php

namespace App\Services;


use Illuminate\Support\Facades\Storage;



class BackupService
{



    /**
     * Create Database Backup
     */


    public function databaseBackup()
    {


        $file =

        'backup-'
        .date('Y-m-d-H-i')
        .'.sql';



        $command = sprintf(

        "pg_dump -U %s %s > storage/app/%s",


        env('DB_USERNAME'),


        env('DB_DATABASE'),


        $file


        );



        shell_exec(
            $command
        );



        return $file;


    }







    /**
     * Backup OCServ Config
     */


    public function ocservBackup(
        $server
    )
    {



        $file =
        'ocserv-'
        .$server->name
        .'-'
        .date('Y-m-d')
        .'.tar.gz';



        $command = sprintf(

        "ssh -p %s %s@%s 'tar -czf /tmp/%s /etc/ocserv'",


        $server->ssh_port,


        $server->ssh_username,


        $server->ip_address,


        $file


        );



        return shell_exec(
            $command
        );


    }



}
