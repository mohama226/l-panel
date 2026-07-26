<?php

declare(strict_types=1);

namespace App\Core;

use PDO;

class Database
{

    private PDO $pdo;


    public function __construct()
    {

        $dsn =
        "mysql:host=".$_ENV['DB_HOST'].
        ";port=".$_ENV['DB_PORT'].
        ";dbname=".$_ENV['DB_DATABASE'].
        ";charset=utf8mb4";


        $this->pdo = new PDO(

            $dsn,

            $_ENV['DB_USERNAME'],

            $_ENV['DB_PASSWORD'],

            [
                PDO::ATTR_ERRMODE =>
                PDO::ERRMODE_EXCEPTION,

                PDO::ATTR_DEFAULT_FETCH_MODE =>
                PDO::FETCH_ASSOC
            ]

        );

    }


    public function connection():PDO
    {
        return $this->pdo;
    }

}
