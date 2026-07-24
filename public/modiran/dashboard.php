<?php

require "../../app/auth.php";
checkLogin();

require "../../app/database.php";

include "../includes/header.php";
include "../includes/sidebar.php";


// آمار کاربران

$totalUsers = 0;
$activeUsers = 0;
$totalTraffic = 0;
$totalAdmins = 0;


try {

    $q = $db->query(
        "SELECT COUNT(*) FROM users"
    );

    $totalUsers = $q->fetchColumn();


    $q = $db->query(
        "SELECT COUNT(*) FROM users WHERE status='active'"
    );

    $activeUsers = $q->fetchColumn();


    $q = $db->query(
        "SELECT SUM(total_gb) FROM users"
    );

    $totalTraffic = $q->fetchColumn() ?: 0;


    $q = $db->query(
        "SELECT COUNT(*) FROM admins"
    );

    $totalAdmins = $q->fetchColumn();


}catch(Exception $e){

}



?>


<div class="container">


<div class="page-title">
داشبورد مدیریت L-PANEL
</div>



<div class="dashboard-grid">


<div class="dashboard-card blue">

<h3>
کل کاربران
</h3>

<div class="dashboard-number">
<?=$totalUsers?>
</div>

<span>
کاربر ثبت شده
</span>

</div>




<div class="dashboard-card green">

<h3>
کاربران فعال
</h3>

<div class="dashboard-number">
<?=$activeUsers?>
</div>

<span>
اتصال فعال
</span>

</div>





<div class="dashboard-card orange">

<h3>
مصرف کل
</h3>

<div class="dashboard-number">
<?=$totalTraffic?>
GB
</div>

<span>
ترافیک مصرفی
</span>

</div>





<div class="dashboard-card purple">

<h3>
مدیران
</h3>

<div class="dashboard-number">
<?=$totalAdmins?>
</div>

<span>
اکانت مدیریتی
</span>

</div>


</div>




<div class="status-box">


<h3>
وضعیت سیستم
</h3>


<p>
وضعیت پنل:

<span class="status-online">
فعال
</span>

</p>



<p>
مدیر وارد شده:

<strong>
<?=htmlspecialchars($_SESSION['admin'])?>
</strong>

</p>



<p>
سطح دسترسی:

<strong>
<?=htmlspecialchars($_SESSION['role'] ?? 'admin')?>
</strong>

</p>



</div>



</div>


<?php

include "../includes/footer.php";

?>
