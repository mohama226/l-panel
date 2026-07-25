<?php
session_start();

if (!isset($_SESSION['admin'])) {
    header("Location: login-admin.php");
    exit;
}

// تعداد کاربران
$users_count = 0;
try {
    $db = new PDO("mysql:host=localhost;dbname=lpanel;charset=utf8", "lpanel_user", "lpanel_pass");
    $stmt = $db->query("SELECT COUNT(*) AS c FROM users");
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    $users_count = $row ? intval($row['c']) : 0;
} catch (Exception $e) {}

// CPU / RAM / Disk
$cpu_load = trim(shell_exec("grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}'"));
$ram_info = shell_exec("free -m | awk 'NR==2{printf \"%s/%s MB\", $3,$2}'");
$disk_info = shell_exec("df -h / | awk 'NR==2{printf \"%s/%s\", $3,$2}'");

// Ocserv connections
$ocserv_conns = trim(shell_exec("ss -ntu | grep ':443' | wc -l"));

// Ocserv port
$ocserv_port = "N/A";
if (file_exists("/etc/ocserv/ocserv.conf")) {
    $ocserv_port = trim(shell_exec("grep '^tcp-port' /etc/ocserv/ocserv.conf | awk '{print $3}'"));
}

// Ocserv version
$ocserv_version = trim(shell_exec("ocserv --version 2>/dev/null | head -n1"));

// Panel version
$panel_version = "1.0.0";
if (file_exists("/var/www/lpanel/VERSION")) {
    $panel_version = trim(file_get_contents("/var/www/lpanel/VERSION"));
}

// Services
$apache_status = trim(shell_exec("systemctl is-active httpd"));
$ocserv_status = trim(shell_exec("systemctl is-active ocserv"));
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

        <!-- Multi Server Manager -->
        <li><a href="admin/ocserv-servers.php">🌐 تنظیمات سرورهای Ocserv</a></li>

        <!-- Resellers -->
        <li><a href="admin/resellers.php">🧑‍💼 نمایندگان</a></li>

        <!-- Ocserv Installer -->
        <li><a href="admin/ocserv-install.php">🔌 نصب Ocserv 1.5.0</a></li>

        <li><a href="logout.php" class="logout">🚪 خروج</a></li>
    </ul>
</div>

<div class="content">
    <h1>خوش آمدید ادمین عزیز 👋</h1>

    <div class="cards">

        <div class="card">
            <h3>تعداد کاربران</h3>
            <p><?php echo $users_count; ?> کاربر</p>
        </div>

        <div class="card">
            <h3>CPU Load</h3>
            <p><?php echo round($cpu_load, 1); ?>%</p>
        </div>

        <div class="card">
            <h3>RAM</h3>
            <p><?php echo $ram_info; ?></p>
        </div>

        <div class="card">
            <h3>Disk</h3>
            <p><?php echo $disk_info; ?></p>
        </div>

        <div class="card">
            <h3>کانکشن‌های Ocserv</h3>
            <p><?php echo $ocserv_conns; ?> اتصال</p>
        </div>

        <div class="card">
            <h3>پورت Ocserv</h3>
            <p><?php echo $ocserv_port; ?></p>
        </div>

        <div class="card">
            <h3>نسخه Ocserv</h3>
            <p><?php echo $ocserv_version; ?></p>
        </div>

        <div class="card">
            <h3>نسخه پنل</h3>
            <p><?php echo $panel_version; ?></p>
        </div>

        <div class="card">
            <h3>وضعیت سرویس‌ها</h3>
            <p>Apache: <?php echo $apache_status; ?><br>
               Ocserv: <?php echo $ocserv_status; ?></p>
        </div>

    </div>
</div>

</body>
</html>
