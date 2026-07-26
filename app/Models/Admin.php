<?php

declare(strict_types=1);

namespace App\Models;


class Admin
{

    public function __construct(
        public int $id,
        public string $username,
        public string $password,
        public string $role
    )
    {}

}
