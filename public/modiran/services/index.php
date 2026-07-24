<?php

require "../../../app/database.php";
require "../../../app/auth.php";
require "../../../app/permissions.php";
require "../../../app/service_manager.php";


checkLogin();

$services=getServices();

echo "<pre>";
print_r($services);
echo "</pre>";

include "../../includes/header.php";
include "../../includes/sidebar.php";

?>


<div class="main">


<h1 class="title">
⚙️ مدیریت سرویس‌های سرور
</h1>



<div class="panel-box">


<table class="service-table">


<tr>

<th>
سرویس
</th>

<th>
وضعیت
</th>

<th>
نوع
</th>

<th>
عملیات
</th>

</tr>



<?php foreach($services as $s): ?>


<tr>


<td>
<?=htmlspecialchars($s['name'])?>
</td>


<td>

<?php if($s['active']=="active"): ?>

<span class="running">
فعال
</span>

<?php else: ?>

<span class="stopped">
متوقف
</span>

<?php endif; ?>


</td>



<td>
<?=$s['sub']?>
</td>



<td>


<a class="btn green"
href="action.php?service=<?=$s['name']?>&action=start">

Start

</a>


<a class="btn red"
href="action.php?service=<?=$s['name']?>&action=stop">

Stop

</a>



<a class="btn orange"
href="action.php?service=<?=$s['name']?>&action=restart">

Restart

</a>


</td>



</tr>


<?php endforeach; ?>


</table>


</div>


</div>


<?php include "../../includes/footer.php"; ?>
