<?php

declare(strict_types=1);

namespace App\Controllers;


class DashboardController
{

    public function index(): void
    {

        $username = $_SESSION['admin_username'] ?? 'Admin';


        require ROOT_PATH.'/app/Views/dashboard.php';

    }

}
