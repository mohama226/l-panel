<?php

require "../app/auth.php";

checkLogin();

?>

<h1>
Welcome <?php echo $_SESSION['admin']; ?>
</h1>

<a href="logout.php">
Logout
</a>
