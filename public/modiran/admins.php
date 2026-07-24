<?php

require "../../app/auth.php";
require "../../app/permissions.php";
require "../../app/database.php";


checkLogin();
requireSuperAdmin();


$admins =
$db
->query(
"SELECT id,username,role,created_at FROM admins"
)
->fetchAll();


include "../includes/header.php";

?>


<div class="container">

<h2>
مدیریت مدیران
</h2>


<a href="admin_create.php">
ایجاد مدیر جدید
</a>


<table border="1" width="100%">

<tr>

<th>
نام کاربری
</th>

<th>
سطح
</th>

<th>
تاریخ
</th>

</tr>


<?php foreach($admins as $a): ?>


<tr>

<td>
<?=$a['username']?>
</td>


<td>
<?=$a['role']?>
</td>


<td>
<?=$a['created_at']?>
</td>

</tr>


<?php endforeach; ?>


</table>


</div>
