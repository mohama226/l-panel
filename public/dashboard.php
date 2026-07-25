<?php
session_start();

// اگر لاگین نشده بود، برگرده به صفحه لاگین
if (!isset($_SESSION['admin'])) {
    header("Location: login-admin.php");
    exit;
}
?>
<!DOCTYPE html>
<html lang="fa">
<head>
    <meta charset="UTF-8">
    <title>L-Panel Dashboard</title>
    <link rel="stylesheet" href="assets/css/panel.css">
</head>
<body>

<div class="box">
    <h2>داشبورد مدیریت L-Panel</h2>

    <ul class="menu">
        <li><a href="users.php">مدیریت کاربران</a></li>
        <li><a href="settings.php">تنظیمات پنل</a></li>
        <li><a href="logs.php">لاگ‌ها</a></li>

        <!-- گزینه جدید نصب Ocserv -->
        <li><a href="admin/ocserv-install.php">نصب Ocserv 1.5.0</a></li>

        <li><a href="logout.php" class="logout">خروج</a></li>
    </ul>
</div>

</body>
</html>
