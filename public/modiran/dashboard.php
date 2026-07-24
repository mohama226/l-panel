<?php

require "../../app/database.php";
require "../../app/auth.php";
require "../../app/permissions.php";

checkLogin();

$totalUsers = 0;
$activeUsers = 0;
$totalAdmins = 0;

$topUsers = [];          // ← اضافه شد
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
        username,
        download_gb,
        upload_gb,
        (download_gb + upload_gb) AS total_gb,
        status
        FROM users
        ORDER BY total_gb DESC
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


<!-- 🔥 مرحله ۳ — جدول ۲۰ کاربر پرمصرف -->
<div class="panel-box">

<h2>🔥 ۲۰ کاربر پرمصرف</h2>

<div class="table-responsive">

<table class="users-table">

<tr>
    <th>کاربر</th>
    <th>دانلود</th>
    <th>آپلود</th>
    <th>مجموع</th>
    <th>وضعیت</th>
</tr>

<?php foreach($topUsers as $u): ?>

<tr>

<td><?=htmlspecialchars($u['username'])?></td>

<td><?=$u['download_gb']?> GB</td>

<td><?=$u['upload_gb']?> GB</td>

<td><b><?=$u['total_gb']?> GB</b></td>

<td>
<?php if($u['status']=="active"): ?>
    <span class="active-status">فعال</span>
<?php else: ?>
    <span class="blocked-status">غیرفعال</span>
<?php endif; ?>
</td>

</tr>

<?php endforeach; ?>

</table>

</div>

</div>


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
