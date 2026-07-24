<?php

require "../../app/database.php";
require "../../app/auth.php";
require "../../app/permissions.php";

checkLogin();


$totalUsers = 0;
$activeUsers = 0;
$totalAdmins = 0;


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


} catch(Exception $e){

}



include "../includes/header.php";
include "../includes/sidebar.php";

?>

<div class="main">


<h1 class="title">
داشبورد مدیریت L-PANEL
</h1>



<div class="cards">


<div class="card blue">

<h3>
👥 کل کاربران
</h3>

<strong>
<?= $totalUsers ?>
</strong>

<p>
کاربر ثبت شده
</p>

</div>




<div class="card green">

<h3>
🟢 کاربران فعال
</h3>

<strong>
<?= $activeUsers ?>
</strong>

<p>
اتصال فعال
</p>

</div>




<div class="card purple">

<h3>
👑 مدیران
</h3>

<strong>
<?= $totalAdmins ?>
</strong>

<p>
اکانت مدیریتی
</p>

</div>




<div class="card orange">

<h3>
⚡ وضعیت پنل
</h3>

<strong>
ONLINE
</strong>

<p>
سیستم فعال است
</p>

</div>



</div>



<div class="panel-box">


<h2>
📊 مصرف روزانه آپلود و دانلود
</h2>


<div style="
height:320px;
display:flex;
align-items:center;
justify-content:center;
color:#777;
">

نمودار مصرف بعد از اتصال جدول ترافیک فعال می‌شود

</div>


</div>




<div class="panel-box">


<h2>
وضعیت حساب مدیر
</h2>


<p>
مدیر وارد شده:

<b>
<?=htmlspecialchars($_SESSION['admin'] ?? '')?>
</b>

</p>



<p>
سطح دسترسی:

<b>
<?=htmlspecialchars($_SESSION['role'] ?? '')?>
</b>

</p>


</div>



</div>


<?php

include "../includes/footer.php";

?>
