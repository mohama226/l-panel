<?php
session_start();
if (!isset($_SESSION['admin'])) {
    header("Location: login-admin.php");
    exit;
}
?>
<!DOCTYPE html>
<html lang="fa">
<head>
    <meta charset="UTF-8">
    <title>داشبورد ادمین</title>
</head>
<body>
    <h1>داشبورد ادمین</h1>

    <ul>
        <li><a href="admin/admins.php">مدیریت ادمین‌ها</a></li>
    </ul>
</body>
</html>
