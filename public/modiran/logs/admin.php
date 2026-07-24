<?php

require "../../../app/auth.php";
checkLogin();

require "../../../app/database.php";


$stmt=$db->query("
SELECT *
FROM admin_logs
ORDER BY id DESC
");


$logs=$stmt->fetchAll();


include "../../includes/header.php";
include "../../includes/sidebar.php";

?>


<div class="content">


<h2>
🛡 لاگ فعالیت مدیران
</h2>


<table>


<tr>

<th>ادمین</th>
<th>عملیات</th>
<th>کاربر</th>
<th>IP</th>
<th>زمان</th>

</tr>


<?php foreach($logs as $l): ?>


<tr>

<td>
<?=$l['admin']?>
</td>


<td>
<?=$l['action']?>
</td>


<td>
<?=$l['target_user']?>
</td>


<td>
<?=$l['ip']?>
</td>


<td>
<?=$l['created_at']?>
</td>


</tr>


<?php endforeach; ?>


</table>


</div>


<?php
include "../../includes/footer.php";
?>
