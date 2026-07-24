<?php


require "../../app/database.php";
require "../../app/auth.php";


checkLogin();
requireSuperAdmin();



if($_POST){


$username=$_POST['username'];

$password=password_hash(
$_POST['password'],
PASSWORD_DEFAULT
);



$stmt=$db->prepare(

"
INSERT INTO admins
(username,password,role,status)
VALUES(?,?,?,?)
"

);



$stmt->execute([

$username,
$password,
$_POST['role'],
'active'

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
ساخت مدیر جدید
</h2>



<form method="post">


<input name="username" placeholder="Username">


<input 
type="password"
name="password"
placeholder="Password"
>



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


<?php include "../includes/footer.php"; ?>
