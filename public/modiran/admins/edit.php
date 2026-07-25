<?php

ini_set('display_errors',1);
ini_set('display_startup_errors',1);
error_reporting(E_ALL);


require "../../../app/database.php";
require "../../../app/auth.php";
require "../../../app/permission.php";

checkLogin();

requireSuperAdmin();


$id=$_GET['id'];


$stmt=$db->prepare(
"SELECT * FROM admins WHERE id=?"
);

$stmt->execute([$id]);

$admin=$stmt->fetch();



if(!$admin){

die("Admin Not Found");

}



if($_SERVER['REQUEST_METHOD']=="POST"){


$firstname=$_POST['firstname'];
$lastname=$_POST['lastname'];
$description=$_POST['description'];

$status=$_POST['status'];
$role=$_POST['role'];



$db->prepare(
"
UPDATE admins SET

firstname=?,
lastname=?,
description=?,
status=?,
role=?

WHERE id=?

"
)->execute([

$firstname,
$lastname,
$description,
$status,
$role,
$id

]);



$db->prepare(
"DELETE FROM admin_permissions WHERE admin_id=?"
)->execute([$id]);



if(isset($_POST['permissions'])){


foreach($_POST['permissions'] as $p){


$db->prepare(
"
INSERT INTO admin_permissions
(admin_id,permission)

VALUES(?,?)

"
)->execute([$id,$p]);


}


}


header("Location:index.php");

exit;


}




$permissions=$db->query(
"SELECT * FROM permissions"
)->fetchAll();



$current=$db->prepare(
"
SELECT permission FROM admin_permissions
WHERE admin_id=?
"
);

$current->execute([$id]);

$currentPermissions=$current->fetchAll(PDO::FETCH_COLUMN);



include "../../includes/header.php";
include "../../includes/sidebar.php";

?>


<div class="content">


<div class="card">


<h2>
✏️ ویرایش مدیر
</h2>



<form method="post">



<label>
نام
</label>

<input class="form-control"
name="firstname"
value="<?=$admin['firstname']?>">



<label>
نام خانوادگی
</label>

<input class="form-control"
name="lastname"
value="<?=$admin['lastname']?>">



<label>
نام کاربری
</label>

<input class="form-control"
value="<?=$admin['username']?>"
disabled>



<label>
توضیحات
</label>


<textarea class="form-control"
name="description"><?=$admin['description']?></textarea>




<label>
نقش
</label>

<select class="form-control" name="role">


<option value="admin"
<?=$admin['role']=="admin"?"selected":""?>>
مدیر
</option>


<option value="superadmin"
<?=$admin['role']=="superadmin"?"selected":""?>>
سوپر ادمین
</option>


</select>




<label>
وضعیت
</label>


<select class="form-control" name="status">

<option value="active"
<?=$admin['status']=="active"?"selected":""?>>
فعال
</option>


<option value="disabled"
<?=$admin['status']=="disabled"?"selected":""?>>
غیرفعال
</option>

</select>



<hr>


<h3>
سطح دسترسی
</h3>


<div class="permission-grid">


<?php foreach($permissions as $p): ?>


<label class="permission-item">


<input type="checkbox"

name="permissions[]"

value="<?=$p['name']?>"

<?=in_array($p['name'],$currentPermissions)?"checked":""?>

>


<?=$p['title']?>


</label>



<?php endforeach; ?>


</div>




<button class="btn-primary">

ذخیره تغییرات

</button>



</form>


</div>


</div>



<?php include "../../includes/footer.php"; ?>
