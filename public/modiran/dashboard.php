<?php

session_start();


if(!isset($_SESSION['admin'])){

header("Location: /modiran");

exit;

}


require "../../app/database.php";


$total_users = $db->query(
"SELECT COUNT(*) FROM users"
)->fetchColumn();



$active_users = $db->query(
"SELECT COUNT(*) FROM users WHERE status='active'"
)->fetchColumn();



$total_download = $db->query(
"SELECT SUM(download_mb) FROM users"
)->fetchColumn();


$total_upload = $db->query(
"SELECT SUM(upload_mb) FROM users"
)->fetchColumn();



$total_traffic =

(($total_download ?? 0)+($total_upload ?? 0))/1024;



include "../includes/header.php";


include "../includes/sidebar.php";


?>


<div class="container">


<div class="topbar">

<h2>
داشبورد مدیریت
</h2>


</div>



<div class="row">



<div class="card">


<h3>
کل کاربران
</h3>


<div class="stat">

<?= $total_users ?>

</div>


<p>
کاربران ثبت شده
</p>


</div>





<div class="card">


<h3>
کاربران فعال
</h3>


<div class="stat">

<?= $active_users ?>

</div>


<p>
حساب فعال
</p>


</div>





<div class="card">


<h3>
ترافیک مصرفی
</h3>


<div class="stat">

<?= round($total_traffic,2) ?>

GB

</div>


<p>
دانلود + آپلود
</p>


</div>



</div>





<div class="card">


<h3>
وضعیت پنل
</h3>


<p>
سیستم فعال است
</p>


<p>

مدیر وارد شده:

<?=htmlspecialchars($_SESSION['admin']);?>

</p>


</div>



</div>



<?php

include "../includes/footer.php";

?>
