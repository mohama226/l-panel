<?php

session_start();

if(!isset($_SESSION['admin'])){

header("Location:/modiran");

exit;

}


require "../../../app/database.php";


$users=$db->query(
"SELECT * FROM users ORDER BY id DESC"
)->fetchAll();



include "../../includes/header.php";

include "../../includes/sidebar.php";

?>


<div class="container">


<div class="page-title">

مدیریت کاربران VPN

</div>



<div class="panel-card">


<a class="btn" href="/modiran/users/create.php">

+ افزودن کاربر

</a>


<a class="btn btn-success" href="/modiran/users/bulk.php">

+ افزودن گروهی

</a>


<br><br>



<table class="admin-table">


<tr>

<th>ID</th>

<th>Username</th>

<th>Expire</th>

<th>Download</th>

<th>Upload</th>

<th>Action</th>

</tr>



<?php foreach($users as $u): ?>


<tr>


<td>
<?=$u['id']?>
</td>


<td>
<?=$u['username']?>
</td>


<td>
<?=$u['expire_date']?>
</td>


<td>
<?=round(($u['download_mb']??0)/1024,2)?>
 GB
</td>


<td>
<?=round(($u['upload_mb']??0)/1024,2)?>
 GB
</td>


<td>


<a class="btn"
href="edit.php?id=<?=$u['id']?>">

ویرایش

</a>



</td>


</tr>


<?php endforeach; ?>


</table>


</div>


</div>


<?php include "../../includes/footer.php"; ?>
