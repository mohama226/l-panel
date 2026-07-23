<?php

require "../../app/auth.php";

checkLogin();

?>


<h1>

پنل مدیریت

</h1>


<p>

سلام

<?= $_SESSION['admin']; ?>

</p>


<a href="../logout.php">

خروج

</a>
