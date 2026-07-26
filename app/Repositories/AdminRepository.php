<?php

declare(strict_types=1);

namespace App\Repositories;


use App\Core\Database;


class AdminRepository
{


    public function __construct(
        private Database $db
    )
    {}



    public function findByUsername(string $username):?array
    {


        $stmt=$this->db
            ->connection()
            ->prepare(
                "SELECT * FROM admins WHERE username=? LIMIT 1"
            );


        $stmt->execute([$username]);


        $result=$stmt->fetch();


        return $result ?: null;

    }



    public function create(
        string $username,
        string $password,
        string $role='superadmin'
    ):bool
    {


        $hash=password_hash(
            $password,
            PASSWORD_BCRYPT
        );


        $stmt=$this->db
            ->connection()
            ->prepare(
            "INSERT INTO admins
            (username,password,role)
            VALUES(?,?,?)"
            );


        return $stmt->execute([
            $username,
            $hash,
            $role
        ]);

    }


}
