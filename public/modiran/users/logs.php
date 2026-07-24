<?php

require "../../../app/auth.php";
checkLogin();

require "../../../app/database.php";
require "../../../app/jalali.php";


$id=$_GET['id'] ?? 0;


$stmt=$db->prepare(
"SELECT * FROM users WHERE id=?"
);

$stmt->execute([$id]);

$user=$stmt->fetch();


if(!$user){

die("User not found");

}



include "../../includes/header.php";
include "../../includes/sidebar.php";

?>


<div class="content">

<div class="users-box">


<h2>
📋 لاگ کاربر:
<?=$user['username']?>
</h2>


<div class="log-box">


<h3>
پنل L-PANEL
</h3>


<p>
نام کاربر:
<?=$user['username']?>
</p>


<p>
حجم:
<?=$user['total_gb']?> GB
</p>


<p>
دانلود:
<?=$user['download'] ?? 0?> MB
</p>


<p>
آپلود:
<?=$user['upload'] ?? 0?> MB
</p>



</div>



<div class="log-box">


<h3>
OCSERV LOG
</h3>


<pre>

<?php


$cmd="journalctl -u ocserv --no-pager | grep "
.escapeshellarg($user['username'])
." | tail -100";


echo htmlspecialchars(shell_exec($cmd));


?>

</pre>


</div>



</div>

</div>



<?php

include "../../includes/footer.php";

?>
