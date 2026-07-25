<?php

require "../../../app/auth.php";
require "../../../app/database.php";
require "../../../app/permission.php";


checkLogin();

requireSuperAdmin();



$admins=$db->query(
"SELECT * FROM admins ORDER BY id DESC"
)->fetchAll();


include "../../includes/header.php";
include "../../includes/sidebar.php";

?>


<link rel="stylesheet" href="/assets/css/admins.css">


<div class="admin-page">


<div class="admin-box">


<div class="admin-title">

👑 مدیریت مدیران

</div>


<a class="admin-btn" href="add.php">

➕ افزودن مدیر

</a>



<table class="admin-table">


<tr>

<th>
نام کاربری
</th>

<th>
نام
</th>

<th>
نقش
</th>

<th>
وضعیت
</th>

<th>
عملیات
</th>

</tr>



<?php foreach($admins as $a): ?>


<tr>


<td>
<?=$a['username']?>
</td>


<td>

<?=$a['first_name']." ".$a['last_name']?>

</td>


<td>

<?=$a['role']?>

</td>



<td>

<?php if($a['status']=="active"): ?>

<span class="badge badge-green">
فعال
</span>

<?php else: ?>

<span class="badge badge-red">
غیرفعال
</span>

<?php endif; ?>


</td>



<td>


<a href="edit.php?id=<?=$a['id']?>">

ویرایش

</a>



<a href="delete.php?id=<?=$a['id']?>">

حذف

</a>


</td>


</tr>


<?php endforeach; ?>


</table>



</div>


</div>


<?php include "../../includes/footer.php"; ?>
