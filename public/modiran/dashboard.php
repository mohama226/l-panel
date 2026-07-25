<?php

ini_set('display_errors',1);
ini_set('display_startup_errors',1);
error_reporting(E_ALL);

// لود init برای BASE_PATH
require_once dirname(__DIR__,2) . "/app/init.php";

// اتصال دیتابیس
require_once BASE_PATH . "/app/database.php";

// ماژول‌های اصلی
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

<div class="main">

    <h1 class="title">داشبورد مدیریت L-PANEL</h1>

    <div class="cards">

        <div class="card blue">
            <h3>👥 کل کاربران</h3>
            <strong><?= $totalUsers ?></strong>
            <p>کاربر ثبت شده</p>
        </div>

        <div class="card green">
            <h3>🟢 کاربران فعال</h3>
            <strong><?= $activeUsers ?></strong>
            <p>اتصال فعال</p>
        </div>

        <div class="card purple">
            <h3>👑 مدیران</h3>
            <strong><?= $totalAdmins ?></strong>
            <p>اکانت مدیریتی</p>
        </div>

        <div class="card orange">
            <h3>⚡ وضعیت پنل</h3>
            <strong>ONLINE</strong>
            <p>سیستم فعال است</p>
        </div>

    </div>

    <div class="panel-box">
        <h2>📊 مصرف روزانه آپلود و دانلود</h2>
        <canvas id="trafficChart" style="max-height:320px;"></canvas>
    </div>

    <div class="dashboard-tables">

        <div class="panel-box">

            <h2>🔥 20 کاربر پر مصرف</h2>

            <table class="dashboard-table">

                <tr>
                    <th>کاربر</th>
                    <th>دانلود</th>
                    <th>آپلود</th>
                    <th>مجموع</th>
                </tr>

                <?php foreach ($topUsers as $u): ?>
                <tr>
                    <td><?= htmlspecialchars($u['username']) ?></td>
                    <td><?= $u['download_mb'] ?> MB</td>
                    <td><?= $u['upload_mb'] ?> MB</td>
                    <td><?= $u['total_mb'] ?> MB</td>
                </tr>
                <?php endforeach; ?>

                <?php if (empty($topUsers)): ?>
                <tr>
                    <td colspan="4">هنوز اطلاعات مصرف ثبت نشده است</td>
                </tr>
                <?php endif; ?>

            </table>

        </div>

        <div class="panel-box">

            <h2>🟢 آخرین کاربران متصل شده</h2>

            <table class="dashboard-table">

                <tr>
                    <th>کاربر</th>
                    <th>آخرین اتصال</th>
                </tr>

                <?php foreach ($recentUsers as $u): ?>
                <tr>
                    <td><?= htmlspecialchars($u['username']) ?></td>
                    <td><?= $u['last_online'] ?></td>
                </tr>
                <?php endforeach; ?>

                <?php if (empty($recentUsers)): ?>
                <tr>
                    <td colspan="2">هنوز اتصال ثبت نشده است</td>
                </tr>
                <?php endif; ?>

            </table>

        </div>

    </div>

    <div class="panel-box">

        <h2>وضعیت حساب مدیر</h2>

        <p>
            مدیر وارد شده:
            <b><?= htmlspecialchars($_SESSION['admin'] ?? '') ?></b>
        </p>

        <p>
            سطح دسترسی:
            <b><?= htmlspecialchars($_SESSION['role'] ?? '') ?></b>
        </p>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
const ctx = document.getElementById('trafficChart');

new Chart(ctx, {
    type: 'bar',
    data: {
        labels: <?= json_encode($chartLabels) ?>,
        datasets: [
            {
                label: 'Download MB',
                data: <?= json_encode($downloadData) ?>,
                backgroundColor: '#2563eb'
            },
            {
                label: 'Upload MB',
                data: <?= json_encode($uploadData) ?>,
                backgroundColor: '#16a34a'
            }
        ]
    },
    options: {
        responsive: true,
        plugins: { legend: { position: 'top' } },
        scales: { y: { beginAtZero: true } }
    }
});
</script>

<?php
include BASE_PATH . "/public/includes/footer.php";
?>
