<?php


require "../../app/database.php";

require "../../app/user_auth.php";


checkUser();



$stmt=$db->prepare(

"SELECT * FROM users WHERE id=?"

);


$stmt->execute([$_SESSION['vpn_id']]);


$user=$stmt->fetch();



?>



<!DOCTYPE html>

<html lang="fa" dir="rtl">


<head>

<meta charset="UTF-8">


<title>

پنل کاربری

</title>


<link rel="stylesheet" href="../assets/css/style.css">


</head>


<body>



<div class="content">



<h2>

سلام <?= $user['username']; ?>

</h2>



<div class="card p-4 shadow">


<h4>

اطلاعات حساب

</h4>



<p>

وضعیت:

<?= $user['status']; ?>

</p>



<p>

تاریخ انقضا:

<?= $user['expire_date']; ?>

</p>



<p>

حجم کل:

<?= $user['total_gb']; ?> GB

</p>



<p>

مصرف شده:

<?= $user['used_gb']; ?> GB

</p>



<p>

باقی مانده:

<?= $user['total_gb']-$user['used_gb']; ?> GB

</p>



</div>



<a href="../logout.php">

خروج

</a>



</div>



</body>

</html>
