<?php

require "../../app/database.php";
require "../../app/auth.php";


checkLogin();
requireSuperAdmin();


$admins=$db->query(

"SELECT * FROM admins ORDER BY id DESC"

)->fetchAll();



include "../includes/header.php";

?>


<div class="container">


<h2>
مدیریت مدیران
</h2>


<a href="admin_create.php">
+ ایجاد مدیر
</a>



<table>


<tr>

<th>
نام
</th>

<th>
نقش
</th>

<th>
وضعیت
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
<?=$a['status']?>
</td>


</tr>


<?php endforeach; ?>


</table>


</div>



<?php include "../includes/footer.php"; ?>
