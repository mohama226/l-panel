<?php

ini_set('display_errors',1);
ini_set('display_startup_errors',1);
error_reporting(E_ALL);

// لود init برای BASE_PATH
require_once dirname(__DIR__,2) . "/app/init.php";

// اتصال مستقیم به دیتابیس (تضمینی)
try {
    $db = new PDO(
        "mysql:host=localhost;dbname=lpanel;charset=utf8",
        "root",
        ""
    );
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(Exception $e){
    die("DB ERROR: " . $e->getMessage());
}

// لود ماژول‌های اصلی
require_once BASE_PATH . "/app/auth.php";
require_once BASE_PATH . "/app/permissions.php";

checkLogin();

// مقادیر اولیه
$totalUsers   = 0;
$activeUsers  = 0;
$totalAdmins  = 0;

$topUsers     = [];
$recentUsers  = [];

$chartLabels  = [];
$downloadData = [];
$uploadData   = [];

try {

    // آمار کلی کاربران و مدیران
    $totalUsers  = $db->query("SELECT COUNT(*) FROM users")->fetchColumn();
    $activeUsers = $db->query("SELECT COUNT(*) FROM users WHERE status='active'")->fetchColumn();
    $totalAdmins = $db->query("SELECT COUNT(*) FROM admins")->fetchColumn();

    // 20 کاربر پرمصرف
    $topUsers = $db->query("
        SELECT
            users.username,
            user_traffic.download_mb,
            user_traffic.upload_mb,
            user_traffic.total_mb
        FROM users
        LEFT JOIN user_traffic
            ON users.id = user_traffic.user_id
        ORDER BY user_traffic.total_mb DESC
        LIMIT 20
    ")->fetchAll();

    // آخرین کاربران متصل شده
    $recentUsers = $db->query("
        SELECT
            users.username,
            user_traffic.last_online
        FROM users
        LEFT JOIN user_traffic
            ON users.id = user_traffic.user_id
        WHERE user_traffic.last_online IS NOT NULL
        ORDER BY user_traffic.last_online DESC
        LIMIT 20
    ")->fetchAll();

    // ترافیک روزانه برای نمودار
    $stmt = $db->query("
        SELECT 
            DATE(created_at) AS day,
            SUM(download_mb) AS download,
            SUM(upload_mb)   AS upload
        FROM traffic_logs
        GROUP BY DATE(created_at)
        ORDER BY day DESC
        LIMIT 7
    ");

    $traffic = array_reverse($stmt->fetchAll());

    foreach ($traffic as $row) {
        $chartLabels[]  = $row['day'];
        $downloadData[] = $row['download'];
        $uploadData[]   = $row['upload'];
    }

} catch (Exception $e) {
    echo "<pre style='direction:ltr;text-align:left;background:#fee;padding:10px;border:1px solid #f00;'>";
    echo "Dashboard error:\n";
    echo $e->getMessage() . "\n\n";
    echo $e->getTraceAsString();
    echo "</pre>";
}

include BASE_PATH . "/public/includes/header.php";
include BASE_PATH . "/public/includes/sidebar.php";

?>

<!-- بقیه کد همان قبلی است بدون تغییر -->

<?php include BASE_PATH . "/public/includes/footer.php"; ?>
