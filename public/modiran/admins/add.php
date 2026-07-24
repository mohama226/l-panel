<?php


require "../../../app/auth.php";
require "../../../app/permission.php";
require "../../../app/database.php";


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
"Location:index.php"
);

exit;


}


?>


<form method="post">


<input name="username"
placeholder="username">


<input name="password"
placeholder="password">


<select name="role">

<option value="admin">
Admin
</option>

<option value="support">
Support
</option>


<option value="reseller">
Reseller
</option>


</select>


<button>
Save
</button>


</form>
