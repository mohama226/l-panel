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


<div class="container">

<h2>
مدیریت مدیران
</h2>


<a href="add.php">
➕ افزودن مدیر
</a>


<table class="table">


<tr>

<th>
ID
</th>

<th>
Username
</th>

<th>
Role
</th>

<th>
Status
</th>

<th>
Action
</th>

</tr>


<?php foreach($admins as $a): ?>


<tr>

<td>
<?=$a['id']?>
</td>


<td>
<?=$a['username']?>
</td>


<td>
<?=$a['role']?>
</td>


<td>
<?=$a['status']?>
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


<?php include "../../includes/footer.php"; ?>
