<?php

namespace App\Repositories;

use App\Core\Database;

class AdminRepository
{
    public function __construct(
        private Database $db
    ){}

}
