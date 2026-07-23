<?php

session_start();


if(!isset($_SESSION['vpn_user'])){

header("Location:index.php");

exit;

}


require "../../app/database.php";


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

<title>User Panel</title>


<link rel="stylesheet" href="../assets/css/user.css">


</head>


<body>



<div class="user-panel">


<div class="user-card">


<h2>

پنل کاربری VPN

</h2>


<h3>

سلام <?= $user['username']; ?>

</h3>



<div class="info">



<div class="box">

<div class="title">

وضعیت

</div>


<div class="value">

<?= $user['status']; ?>

</div>

</div>



<div class="box">

<div class="title">

تاریخ انقضا

</div>


<div class="value">

<?= $user['expire_date']; ?>

</div>

</div>



<div class="box">

<div class="title">

حجم کل

</div>


<div class="value">

<?= $user['total_gb']; ?> GB

</div>

</div>



<div class="box">

<div class="title">

مصرف شده

</div>


<div class="value">

<?= $user['used_gb']; ?> GB

</div>

</div>



</div>


<br>


<a href="../logout.php">

خروج

</a>


</div>


</div>


</body>

</html>
