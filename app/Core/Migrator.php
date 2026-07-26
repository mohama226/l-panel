<?php

declare(strict_types=1);

namespace App\Core;

class Migrator
{

    public function run():void
    {

        $db = new Database();

        $files =
        glob(ROOT_PATH.'/database/migrations/*.sql');


        foreach($files as $file){


            $sql=file_get_contents($file);


            $db->connection()
               ->exec($sql);


        }


    }

}
