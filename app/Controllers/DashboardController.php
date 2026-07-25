<?php
require_once __DIR__ . '/../Core/Auth.php';

class DashboardController
{
    public function index()
    {
        Auth::requireAdmin();

        echo "<h1>داشبورد مدیریت</h1>";
        echo "<p>خوش آمدید مدیر عزیز</p>";
        echo "<a href='/auth/logout'>خروج</a>";
    }
}
