<?php

declare(strict_types=1);

namespace App\Core;

use PDO;

class Database
{
    private PDO $pdo;

    public function __construct()
    {
        $db=require ROOT_PATH.'/config/database.php';

        $dsn="mysql:host={$db['host']};port={$db['port']};dbname={$db['database']};charset={$db['charset']}";

        $this->pdo=new PDO(

            $dsn,

            $db['username'],

            $db['password'],

            [

                PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION,

                PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC,

            ]

        );
    }

    public function pdo():PDO
    {
        return $this->pdo;
    }
}
