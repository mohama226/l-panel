<?php

require "../../../app/auth.php";
requireSuperAdmin();

require "../../../app/database.php";


$id=$_GET['id'];


$stmt=$db->prepare(
"SELECT * FROM admins WHERE id=?"
);

$stmt->execute([$id]);


$admin=$stmt->fetch();



if(!$admin){

die("مدیر پیدا نشد");

}




if($_POST){



$fullname=$_POST['fullname'];

$role=$_POST['role'];

$status=$_POST['status'];



$db->prepare(

"UPDATE admins
SET fullname=?,
role=?,
status=?
WHERE id=?"

)->execute([

$fullname,
$role,
$status,
$id

]);



header(
"Location:index.php"
);

exit;


}



?>


<h2>
ویرایش مدیر
</h2>


<form method="post">


<input 
name="fullname"
value="<?=$admin['fullname']?>">


<br>


<select name="role">


<option 
value="admin"
<?=($admin['role']=="admin"?"selected":"")?>
>
مدیر
</option>



<option
value="superadmin"
<?=($admin['role']=="superadmin"?"selected":"")?>
>
سوپر ادمین
</option>


</select>



<br>



<select name="status">


<option
value="active"
<?=($admin['status']=="active"?"selected":"")?>
>
فعال
</option>


<option
value="blocked"
<?=($admin['status']=="blocked"?"selected":"")?>
>
مسدود
</option>


</select>



<br>


<button>
ذخیره
</button>


</form>
