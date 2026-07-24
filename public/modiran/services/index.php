<?php

ini_set('display_errors',1);
ini_set('display_startup_errors',1);
error_reporting(E_ALL);

/* 🔥 مسیرهای جدید و استاندارد */
require_once dirname(__DIR__,3)."/app/init.php";

require_once BASE_PATH."/app/database.php";
require_once BASE_PATH."/app/auth.php";
require_once BASE_PATH."/app/permissions.php";
require_once BASE_PATH."/app/service_manager.php";

checkLogin();

$services = getServices();

/* 🔥 include های استاندارد */
include BASE_PATH."/public/includes/header.php";
include BASE_PATH."/public/includes/sidebar.php";

?>

<div class="main">

<h1 class="title">
⚙️ مدیریت سرویس‌های سرور
</h1>

<div class="panel-box">

<table class="service-table">

<tr>
    <th>سرویس</th>
    <th>وضعیت</th>
    <th>نوع</th>
    <th>عملیات</th>
</tr>

<?php foreach($services as $s): ?>

<tr>

<td>
    <?= htmlspecialchars($s['name']) ?>
</td>

<td>
<?php if($s['active'] == "active"): ?>
    <span class="running">فعال</span>
<?php else: ?>
    <span class="stopped">متوقف</span>
<?php endif; ?>
</td>

<td>
    <?= $s['sub'] ?>
</td>

<td>

    <a class="btn green"
       href="action.php?service=<?= $s['name'] ?>&action=start">
       Start
    </a>

    <a class="btn red"
       href="action.php?service=<?= $s['name'] ?>&action=stop">
       Stop
    </a>

    <a class="btn orange"
       href="action.php?service=<?= $s['name'] ?>&action=restart">
       Restart
    </a>

</td>

</tr>

<?php endforeach; ?>

</table>

</div>

</div>

<?php include BASE_PATH."/public/includes/footer.php"; ?>
