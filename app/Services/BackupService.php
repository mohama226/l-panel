<?php

namespace App\Services;


use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;



class BackupService
{



    /**
     * Database Backup
     */


    public function databaseBackup()
    {


        $database = config(
            'database.connections.pgsql.database'
        );


        $file = 
        "backup_"
        .date('Y-m-d_H-i-s')
        .".sql";



        $path = storage_path(
            "app/backups/".$file
        );



        $command = sprintf(

        "pg_dump %s > %s",

        $database,

        $path

        );



        exec($command);



        return $path;


    }





    /**
     * Full Panel Backup
     */


    public function fullBackup()
    {



        $file =
        "lpanel_backup_"
        .date('Y-m-d')
        .".tar.gz";



        $path =
        storage_path(
            "app/backups/".$file
        );



        $command = sprintf(

        "tar -czf %s %s",

        $path,

        base_path()

        );



        exec($command);



        return $path;


    }





    /**
     * Delete Old Backups
     */


    public function cleanOldBackups(
        int $days = 30
    )
    {


        $files =
        Storage::files(
            'backups'
        );



        foreach($files as $file){


            if(
                Storage::lastModified($file)
                <
                now()
                ->subDays($days)
                ->timestamp
            )
            {


                Storage::delete($file);


            }


        }



    }



}
