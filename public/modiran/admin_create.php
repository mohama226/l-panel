<?php

require "../../app/auth.php";
require "../../app/permissions.php";
require "../../app/database.php";


checkLogin();
requireSuperAdmin();



if($_POST){


$username=$_POST['username'];

$password=password_hash(
$_POST['password'],
PASSWORD_DEFAULT
);


$role=$_POST['role'];



$stmt=$db->prepare(
"INSERT INTO admins
(username,password,role)
VALUES(?,?,?)"
);


$stmt->execute([
$username,
$password,
$role
]);


header(
"Location: admins.php"
);

exit;

}



include "../includes/header.php";


?>


<div class="container">


<h2>
ایجاد مدیر
</h2>


<form method="post">


<input name="username"
placeholder="نام کاربری">


<input 
type="password"
name="password"
placeholder="رمز">


<select name="role">


<option value="admin">
Admin
</option>


<option value="superadmin">
Super Admin
</option>


</select>


<button>
ذخیره
</button>


</form>


</div>
