<?php

require "../../app/database.php";
require "../../app/auth.php";
require "../../app/permissions.php";

checkLogin();

$totalUsers = 0;
$activeUsers = 0;
$totalAdmins = 0;

$chartLabels = [];
$downloadData = [];
$uploadData = [];   // ← اضافه شد

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


    /* 🔥 بخش جدید: دریافت ترافیک ۷ روز اخیر */

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

<!-- 🔥 اضافه‌شده: Chart.js -->
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
