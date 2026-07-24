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
(username,password,role)

VALUES
(?,?,?)

"

);



$stmt->execute([

$username,

$password,

$_POST['role']

]);



echo "Admin Created";


}



?>


<form method="post">


<input name="username" placeholder="username">


<input name="password" placeholder="password">


<select name="role">


<option value="admin">
Admin
</option>


<option value="superadmin">
Super Admin
</option>


</select>


<button>
Create
</button>


</form>
