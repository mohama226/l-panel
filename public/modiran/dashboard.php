<?php

require "../../app/database.php";
require "../../app/auth.php";

checkLogin();


$totalUsers = 0;
$activeUsers = 0;
$totalAdmins = 0;
$totalTraffic = 0;


try {


$totalUsers =
$db->query(
"SELECT COUNT(*) FROM users"
)->fetchColumn();



$activeUsers =
$db->query(
"SELECT COUNT(*) FROM users WHERE status='active'"
)->fetchColumn();



$totalAdmins =
$db->query(
"SELECT COUNT(*) FROM admins"
)->fetchColumn();



$totalTraffic =
$db->query(
"SELECT COALESCE(SUM(total_gb),0) FROM users"
)->fetchColumn();



}catch(Exception $e){}



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
کل کاربران
</h3>

<strong>
<?=$totalUsers?>
</strong>

<p>
VPN Users
</p>

</div>




<div class="card green">

<h3>
کاربران فعال
</h3>

<strong>
<?=$activeUsers?>
</strong>

<p>
Active
</p>

</div>





<div class="card orange">

<h3>
مصرف ترافیک
</h3>

<strong>
<?=$totalTraffic?>
 GB
</strong>

<p>
Traffic
</p>

</div>





<?php if(isSuperAdmin()): ?>


<div class="card purple">

<h3>
مدیران
</h3>

<strong>
<?=$totalAdmins?>
</strong>

<p>
Administrators
</p>


</div>


<?php endif; ?>


</div>





<div class="panel-box">


<h2>
وضعیت سیستم
</h2>


<div class="status">

<span></span>

پنل آنلاین است

</div>



<p>

مدیر:

<b>
<?=htmlspecialchars(currentAdmin())?>
</b>

</p>



<p>

سطح:

<b>
<?=htmlspecialchars(currentRole())?>
</b>

</p>


</div>



</div>



<?php

include "../includes/footer.php";

?>
