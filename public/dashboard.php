<?php
session_start();

if (!isset($_SESSION['admin'])) {
    header("Location: login-admin.php");
    exit;
}

// تعداد کاربران (فرض: جدول users در دیتابیس lpanel)
$users_count = 0;
try {
    $db = new PDO("mysql:host=localhost;dbname=lpanel;charset=utf8", "lpanel_user", "lpanel_pass");
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $stmt = $db->query("SELECT COUNT(*) AS c FROM users");
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    $users_count = $row ? intval($row['c']) : 0;
} catch (Exception $e) {
    $users_count = 0;
}

// وضعیت CPU / RAM / Disk
$cpu_load = trim(shell_exec("grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}'"));
$ram_info = shell_exec("free -m | awk 'NR==2{printf \"%s/%s MB\", $3,$2}'");
$disk_info = shell_exec("df -h / | awk 'NR==2{printf \"%s/%s\", $3,$2}'");

// تعداد کانکشن‌های Ocserv
$ocserv_conns = trim(shell_exec("ss -ntu | grep ':443' | wc -l")); // اگر پورت دیگری است بعداً تنظیم می‌کنیم

// پورت فعلی Ocserv
$ocserv_port = "N/A";
if (file_exists("/etc/ocserv/ocserv.conf")) {
    $ocserv_port = trim(shell_exec("grep '^tcp-port' /etc/ocserv/ocserv.conf | awk '{print $3}'"));
}

// نسخه Ocserv
$ocserv_version = trim(shell_exec("ocserv --version 2>/dev/null | head -n1"));

// نسخه پنل (ثابت یا از فایل)
$panel_version = "1.0.0";
if (file_exists("/var/www/lpanel/VERSION")) {
    $panel_version = trim(file_get_contents("/var/www/lpanel/VERSION"));
}

// وضعیت سرویس‌ها
$apache_status = trim(shell_exec("systemctl is-active httpd 2>/dev/null"));
$ocserv_status = trim(shell_exec("systemctl is-active ocserv 2>/dev/null"));
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
        <li><a href="admin/ocserv-install.php">🔌 نصب Ocserv 1.5.0</a></li>
        <li><a href="logout.php" class="logout">🚪 خروج</a></li>
    </ul>
</div>

<div class="content">
    <h1>خوش آمدید ادمین عزیز 👋</h1>

    <div class="cards">

        <!-- تعداد کاربران -->
        <div class="card">
            <div class="card-icon">
                <!-- SVG آیکون یوزر -->
                <svg viewBox="0 0 24 24">
                    <circle cx="12" cy="8" r="4"></circle>
                    <path d="M4 20c0-4 4-6 8-6s8 2 8 6"></path>
                </svg>
            </div>
            <h3>تعداد کاربران</h3>
            <p><?php echo $users_count; ?> کاربر ثبت‌شده</p>
        </div>

        <!-- وضعیت CPU -->
        <div class="card">
            <div class="card-icon">
                <!-- SVG آیکون CPU -->
                <svg viewBox="0 0 24 24">
                    <rect x="7" y="7" width="10" height="10" rx="2"></rect>
                    <path d="M9 1v3M15 1v3M9 20v3M15 20v3M1 9h3M1 15h3M20 9h3M20 15h3"></path>
                </svg>
            </div>
            <h3>CPU Load</h3>
            <p><?php echo $cpu_load ? round($cpu_load, 1) . '%' : 'N/A'; ?></p>
        </div>

        <!-- وضعیت RAM -->
        <div class="card">
            <div class="card-icon">
                <!-- SVG آیکون RAM -->
                <svg viewBox="0 0 24 24">
                    <rect x="3" y="7" width="18" height="10" rx="2"></rect>
                    <path d="M7 7v10M12 7v10M17 7v10"></path>
                </svg>
            </div>
            <h3>RAM</h3>
            <p><?php echo $ram_info ?: 'N/A'; ?></p>
        </div>

        <!-- وضعیت Disk -->
        <div class="card">
            <div class="card-icon">
                <!-- SVG آیکون دیسک -->
                <svg viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="8"></circle>
                    <circle cx="12" cy="12" r="2"></circle>
                </svg>
            </div>
            <h3>Disk</h3>
            <p><?php echo $disk_info ?: 'N/A'; ?></p>
        </div>

        <!-- کانکشن‌های Ocserv -->
        <div class="card">
            <div class="card-icon">
                <!-- SVG آیکون شبکه -->
                <svg viewBox="0 0 24 24">
                    <circle cx="6" cy="12" r="3"></circle>
                    <circle cx="18" cy="7" r="3"></circle>
                    <circle cx="18" cy="17" r="3"></circle>
                    <path d="M8.5 10.5l7-2M8.5 13.5l7 2"></path>
                </svg>
            </div>
            <h3>کانکشن‌های Ocserv</h3>
            <p><?php echo $ocserv_conns; ?> اتصال فعال</p>
        </div>

        <!-- پورت فعلی Ocserv -->
        <div class="card">
            <div class="card-icon">
                <!-- SVG آیکون پورت -->
                <svg viewBox="0 0 24 24">
                    <rect x="5" y="5" width="14" height="14" rx="2"></rect>
                    <path d="M9 9h6v6H9z"></path>
                </svg>
            </div>
            <h3>پورت Ocserv</h3>
            <p><?php echo $ocserv_port ?: 'N/A'; ?></p>
        </div>

        <!-- نسخه Ocserv -->
        <div class="card">
            <div class="card-icon">
                <!-- SVG آیکون نسخه -->
                <svg viewBox="0 0 24 24">
                    <path d="M5 3h14v4H5zM5 9h14v12H5z"></path>
                </svg>
            </div>
            <h3>نسخه Ocserv</h3>
            <p><?php echo $ocserv_version ?: 'N/A'; ?></p>
        </div>

        <!-- نسخه پنل -->
        <div class="card">
            <div class="card-icon">
                <!-- SVG آیکون پنل -->
                <svg viewBox="0 0 24 24">
                    <rect x="3" y="4" width="18" height="16" rx="2"></rect>
                    <path d="M3 9h18"></path>
                </svg>
            </div>
            <h3>نسخه پنل</h3>
            <p><?php echo $panel_version; ?></p>
        </div>

        <!-- وضعیت سرویس‌ها -->
        <div class="card">
            <div class="card-icon">
                <!-- SVG آیکون سرویس -->
                <svg viewBox="0 0 24 24">
                    <path d="M4 4h16v6H4zM4 14h16v6H4z"></path>
                </svg>
            </div>
            <h3>وضعیت سرویس‌ها</h3>
            <p>Apache: <?php echo $apache_status ?: 'N/A'; ?><br>
               Ocserv: <?php echo $ocserv_status ?: 'N/A'; ?></p>
        </div>

    </div>
</div>

</body>
</html>
