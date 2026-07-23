<?php


require "../../app/user_auth.php";

checkUserLogin();


require "../../app/database.php";


require "../../app/jalali.php";



$id=$_SESSION['vpn_user'];



$stmt=$db->prepare(

"SELECT * FROM users WHERE id=?"

);



$stmt->execute([$id]);



$user=$stmt->fetch();



include "../includes/header.php";


?>


<div class="content">


<div class="users-box">


<h2>

👤 پنل کاربری

</h2>



<div class="card">


<p>

نام کاربری:

<b>

<?=$user['username']?>

</b>

</p>




<p>

تاریخ انقضا میلادی:

<b>

<?=$user['expire_date']?>

</b>

</p>



<p>

تاریخ انقضا شمسی:

<b>

<?=jalali_date($user['expire_date'])?>

</b>

</p>




<p>

حجم کل:

<b>

<?=$user['total_gb']?>

GB

</b>

</p>




<p>

دانلود:

<b>

<?=($user['download'] ?? 0)?>

MB

</b>

</p>




<p>

آپلود:

<b>

<?=($user['upload'] ?? 0)?>

MB

</b>

</p>



</div>



</div>


</div>



<?php

include "../includes/footer.php";

?>
