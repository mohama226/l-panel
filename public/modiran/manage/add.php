<?php

require "../../../app/auth.php";
requireSuperAdmin();

require "../../../app/database.php";


$error="";


if($_POST){


$username=$_POST['username'];

$password=$_POST['password'];

$fullname=$_POST['fullname'];

$role=$_POST['role'];



if($username && $password){


$hash=password_hash(
$password,
PASSWORD_DEFAULT
);



$stmt=$db->prepare(
"INSERT INTO admins
(username,password,fullname,role,status)
VALUES(?,?,?,?,?)"
);


$stmt->execute([

$username,
$hash,
$fullname,
$role,
'active'

]);



header(
"Location:index.php"
);

exit;



}else{


$error="اطلاعات ناقص است";


}


}


?>


<!DOCTYPE html>

<html lang="fa" dir="rtl">

<head>

<meta charset="UTF-8">

<title>
ساخت مدیر جدید
</title>

</head>


<body>


<h2>
ساخت مدیر جدید
</h2>



<?php if($error): ?>

<p>
<?=$error?>
</p>

<?php endif; ?>



<form method="post">


<input name="username"
placeholder="نام کاربری">



<br>


<input name="fullname"
placeholder="نام کامل">


<br>



<input type="password"
name="password"
placeholder="رمز عبور">


<br>



<select name="role">


<option value="admin">
مدیر
</option>


<option value="superadmin">
سوپر ادمین
</option>


</select>


<br>



<button>
ذخیره
</button>



</form>


</body>

</html>
