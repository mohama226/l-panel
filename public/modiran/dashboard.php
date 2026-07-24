<?php

require "../../app/database.php";
require "../../app/auth.php";
require "../../app/permissions.php";

checkLogin();

$totalUsers = 0;
$activeUsers = 0;
$totalAdmins = 0;

$topUsers = [];          // ← اضافه شد
$recentUsers = [];       // ← اضافه شد

$chartLabels = [];
$downloadData = [];
$uploadData = [];

try {

    $totalUsers = $db->query(
        "SELECT COUNT(*) FROM users"
    )->fetchColumn();

    $activeUsers = $db->query(
        "SELECT COUNT(*) FROM users WHERE status='active'"
    )->fetchColumn();

    $totalAdmins = $db->query(
        "SELECT COUNT(*) FROM admins"
    )->fetchColumn();

    /* 🔥 مرحله ۲ — دریافت ۲۰ کاربر پرمصرف */
    $topUsers = $db->query("
        SELECT
        users.username,
        user_traffic.download_mb,
        user_traffic.upload_mb,
        user_traffic.total_mb
        FROM users
        LEFT JOIN user_traffic
        ON users.id=user_traffic.user_id
        ORDER BY user_traffic.total_mb DESC
        LIMIT 20
    ")->fetchAll();

    /* 🔥 مرحله ۲ — دریافت ۲۰ کاربر اخیراً متصل شده */
    $recentUsers = $db->query("
        SELECT
        users.username,
        user_traffic.last_online
        FROM users
        LEFT JOIN user_traffic
        ON users.id=user_traffic.user_id
        WHERE user_traffic.last_online IS NOT NULL
        ORDER BY user_traffic.last_online DESC
        LIMIT 20
    ")->fetchAll();

    /* 🔥 دریافت ترافیک ۷ روز اخیر */
    $stmt = $db->query("
        SELECT 
        DATE(created_at) as day,
        SUM(download_mb) as download,
        SUM(upload_mb) as upload
        FROM traffic_logs
        GROUP BY DATE(created_at)
        ORDER BY day DESC
        LIMIT 7
    ");

    $traffic = $stmt->fetchAll();
    $traffic = array_reverse($traffic);

    foreach($traffic as $row){
        $chartLabels[] = $row['day'];
        $downloadData[] = $row['download'];
        $uploadData[]   = $row['upload'];
    }

} catch(Exception $e){}

include "../includes/header.php";
include "../includes/sidebar.php";

?>

<div class="main">

<h1 class="title">
داشبورد مدیریت L-PANEL
</h1>

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


<!-- 🔥 نمودار مصرف روزانه -->
<div class="panel-box">

<h2>📊 مصرف روزانه آپلود و دانلود</h2>

<canvas id="trafficChart" style="max-height:320px;"></canvas>

</div>

</div> <!-- پایان بخش نمودار -->

<!-- 🔥 بخش جدید — جدول‌های داشبورد -->
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

<?php foreach($topUsers as $u): ?>

<tr>

<td><?= $u['username'] ?></td>

<td><?= $u['download_mb'] ?> MB</td>

<td><?= $u['upload_mb'] ?> MB</td>

<td><?= $u['total_mb'] ?> MB</td>

</tr>

<?php endforeach; ?>

</table>

</div>


<div class="panel-box">

<h2>🟢 آخرین کاربران متصل شده</h2>

<table class="dashboard-table">

<tr>
    <th>کاربر</th>
    <th>آخرین اتصال</th>
</tr>

<?php foreach($recentUsers as $u): ?>

<tr>

<td><?= $u['username'] ?></td>

<td><?= $u['last_online'] ?></td>

</tr>

<?php endforeach; ?>

</table>

</div>

</div> <!-- پایان dashboard-tables -->


<div class="panel-box">

<h2>وضعیت حساب مدیر</h2>

<p>
مدیر وارد شده:
<b><?=htmlspecialchars($_SESSION['admin'] ?? '')?></b>
</p>

<p>
سطح دسترسی:
<b><?=htmlspecialchars($_SESSION['role'] ?? '')?></b>
</p>

</div>

</div>

<!-- 🔥 نمودار Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>

const ctx = document.getElementById('trafficChart');

new Chart(ctx, {
    type:'bar',
    data:{
        labels: <?=json_encode($chartLabels)?>,
        datasets:[
            {
                label:'Download MB',
                data: <?=json_encode($downloadData)?>,
                backgroundColor:'#2563eb'
            },
            {
                label:'Upload MB',
                data: <?=json_encode($uploadData)?>,
                backgroundColor:'#16a34a'
            }
        ]
    },
    options:{
        responsive:true,
        plugins:{
            legend:{ position:'top' }
        },
        scales:{
            y:{ beginAtZero:true }
        }
    }
});

</script>

<?php
include "../includes/footer.php";
?>
