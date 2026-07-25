<?php

require "../../../app/auth.php";
require "../../../app/permission.php";
require "../../../app/database.php";


checkLogin();

requireSuperAdmin();


$admins=$db->query(
    "SELECT * FROM admins ORDER BY id DESC"
)->fetchAll();



include "../../includes/header.php";
include "../../includes/sidebar.php";

?>


<div class="content">


<div class="page-title">

<h1>
👑 مدیریت مدیران
</h1>

<p>
مدیریت حساب‌های مدیریتی پنل L-PANEL
</p>

</div>



<div class="admin-box">


<div class="admin-header">


<h2>
لیست مدیران
</h2>



<a class="add-admin-btn" href="add.php">
➕ افزودن مدیر
</a>


</div>





<div class="table-wrapper">


<table class="admin-table">


<thead>

<tr>

<th>
شناسه
</th>


<th>
نام کاربری
</th>


<th>
سطح دسترسی
</th>


<th>
وضعیت
</th>


<th>
عملیات
</th>


</tr>

</thead>



<tbody>


<?php foreach($admins as $a): ?>


<tr>


<td>
<?=$a['id']?>
</td>



<td class="username">

👤 <?=$a['username']?>

</td>



<td>

<span class="role-badge">

<?=$a['role']?>

</span>

</td>



<td>


<?php if($a['status']=="active"): ?>

<span class="status-active">
فعال
</span>


<?php else: ?>


<span class="status-disabled">
غیرفعال
</span>


<?php endif; ?>


</td>



<td>


<a class="edit-btn"
href="edit.php?id=<?=$a['id']?>">
✏️ ویرایش
</a>



<a class="delete-btn"
href="delete.php?id=<?=$a['id']?>"
onclick="return confirm('حذف شود؟')">
🗑 حذف
</a>



</td>


</tr>


<?php endforeach; ?>


</tbody>


</table>


</div>


</div>


</div>



<?php include "../../includes/footer.php"; ?>
