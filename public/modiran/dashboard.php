<?php

require "../../app/database.php";
require "../../app/auth.php";
require "../../app/permissions.php";

checkLogin();


$totalUsers = 0;
$activeUsers = 0;
$totalAdmins = 0;
$totalBlocked = 0;
$recentUsers = [];


try {


    $totalUsers =
    $db->query(
        "SELECT COUNT(*) FROM users"
    )->fetchColumn();



    $activeUsers =
    $db->query(
        "SELECT COUNT(*) FROM users WHERE status='active'"
    )->fetchColumn();



    $totalBlocked =
    $db->query(
        "SELECT COUNT(*) FROM users WHERE status='blocked'"
    )->fetchColumn();



    $totalAdmins =
    $db->query(
        "SELECT COUNT(*) FROM admins"
    )->fetchColumn();



    $recentUsers =
    $db->query(
        "
        SELECT username,status,created_at
        FROM users
        ORDER BY id DESC
        LIMIT 10
        "
    )->fetchAll();



}catch(Exception $e){

}



include "../includes/header.php";
include "../includes/sidebar.php";

?>


<div class="content">


<div class="page-title">

<h1>
داشبورد مدیریت
</h1>

<p>
نمای کلی وضعیت پنل L-PANEL
</p>

</div>



<div class="dashboard-grid">


<div class="dashboard-card blue">


<div class="icon">
👥
</div>


<h3>
کل کاربران
</h3>


<strong>
<?=$totalUsers?>
</strong>


<span>
کاربر ثبت شده
</span>


</div>





<div class="dashboard-card green">


<div class="icon">
✅
</div>


<h3>
کاربران فعال
</h3>


<strong>
<?=$activeUsers?>
</strong>


<span>
اکانت فعال
</span>


</div>






<div class="dashboard-card red">


<div class="icon">
🚫
</div>


<h3>
کاربران مسدود
</h3>


<strong>
<?=$totalBlocked?>
</strong>


<span>
Blocked
</span>


</div>






<?php if(isSuperAdmin()): ?>


<div class="dashboard-card purple">


<div class="icon">
👑
</div>


<h3>
مدیران
</h3>


<strong>
<?=$totalAdmins?>
</strong>


<span>
Admin Accounts
</span>


</div>


<?php endif; ?>


</div>





<div class="dashboard-two">


<div class="panel-box">


<h2>
آخرین کاربران ساخته شده
</h2>



<table>


<tr>

<th>
نام کاربری
</th>


<th>
وضعیت
</th>


<th>
تاریخ
</th>


</tr>



<?php foreach($recentUsers as $u): ?>


<tr>

<td>
<?=htmlspecialchars($u['username'])?>
</td>


<td>


<?php if($u['status']=="active"): ?>

<span class="badge green-badge">
فعال
</span>


<?php else: ?>


<span class="badge red-badge">
مسدود
</span>


<?php endif; ?>


</td>


<td>
<?=$u['created_at']?>
</td>


</tr>


<?php endforeach; ?>


</table>


</div>





<div class="panel-box">


<h2>
وضعیت سیستم
</h2>



<div class="system-status">


<span class="online-dot"></span>

پنل آنلاین است


</div>



<hr>


<p>

مدیر وارد شده:

<b>
<?=htmlspecialchars($_SESSION['admin'])?>
</b>

</p>



<p>

سطح دسترسی:

<b>
<?=htmlspecialchars($_SESSION['role'])?>
</b>

</p>



</div>



</div>



</div>



<?php

include "../includes/footer.php";

?>
