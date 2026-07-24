<?php

require "../../../app/database.php";
require "../../../app/auth.php";
require "../../../app/permissions.php";

checkLogin();
requireSuperAdmin();


$id = $_GET['id'] ?? null;


if(!$id){

    die("Invalid ID");

}



$stmt=$db->prepare("
SELECT id,username,role,status
FROM admins
WHERE id=?
");


$stmt->execute([$id]);

$admin=$stmt->fetch();


if(!$admin){

    die("Admin Not Found");

}



if($_POST){


$username=$_POST['username'];

$role=$_POST['role'];

$status=$_POST['status'];



$stmt=$db->prepare("
UPDATE admins
SET username=?,
role=?,
status=?
WHERE id=?
");


$stmt->execute([

$username,
$role,
$status,
$id

]);



header("Location:index.php");

exit;


}



include "../../includes/header.php";
include "../../includes/sidebar.php";

?>


<div class="content">


<h2>
ویرایش مدیر
</h2>



<form method="post" class="form-box">


<label>
نام کاربری
</label>

<input 
name="username"
value="<?=$admin['username']?>"
>



<label>
سطح دسترسی
</label>


<select name="role">


<option value="admin"
<?=$admin['role']=="admin"?'selected':''?>>

Admin

</option>


<option value="superadmin"
<?=$admin['role']=="superadmin"?'selected':''?>>

Super Admin

</option>


</select>




<label>
وضعیت
</label>


<select name="status">


<option value="active"
<?=$admin['status']=="active"?'selected':''?>>

فعال

</option>


<option value="disabled"
<?=$admin['status']=="disabled"?'selected':''?>>

غیرفعال

</option>


</select>



<button>

ذخیره

</button>


</form>


</div>


<?php

include "../../includes/footer.php";

?>
