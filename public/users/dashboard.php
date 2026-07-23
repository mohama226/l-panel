<?php

session_start();


if(!isset($_SESSION['vpn_user'])){


header("Location: index.php");

exit;


}


?>


<h1>

پنل کاربری VPN

</h1>


<p>

کاربر:

<?= $_SESSION['vpn_user']; ?>

</p>



<div>

تاریخ انقضا:
در آینده از دیتابیس خوانده می‌شود

</div>



<a href="../logout.php">

خروج

</a>
