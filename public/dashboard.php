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
    <title>L-Panel Admin Dashboard</title>
    <link rel="stylesheet" href="assets/css/admin-dashboard.css">
</head>

<body>

<div class="sidebar">
    <div class="logo">
        <h2>L-Panel</h2>
        <span>Admin Dashboard</span>
    </div>

    <ul class="menu">
        <li><a href="dashboard.php">🏠 داشبورد</a></li>
        <li><a href="users.php">👤 مدیریت کاربران</a></li>
        <li><a href="settings.php">⚙️ تنظیمات پنل</a></li>
        <li><a href="logs.php">📄 لاگ‌ها</a></li>

        <!-- گزینه نصب Ocserv -->
        <li><a href="admin/ocserv-install.php">🔌 نصب Ocserv 1.5.0</a></li>

        <li><a href="logout.php" class="logout">🚪 خروج</a></li>
    </ul>
</div>

<div class="content">
    <h1>خوش آمدید ادمین عزیز 👋</h1>

    <div class="cards">

        <div class="card">
            <h3>وضعیت پنل</h3>
            <p>پنل فعال و در حال اجراست.</p>
        </div>

        <div class="card">
            <h3>Apache Status</h3>
            <p><?php echo shell_exec("systemctl is-active httpd"); ?></p>
        </div>

        <div class="card">
            <h3>Ocserv Status</h3>
            <p><?php echo shell_exec("systemctl is-active ocserv"); ?></p>
        </div>

    </div>
</div>

</body>
</html>
