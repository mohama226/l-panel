<?php

require "../app/database.php";


session_start();


$error="";


if($_POST){


$username=$_POST['username'];

$password=$_POST['password'];



$stmt=$db->prepare(
"SELECT * FROM admins WHERE username=?"
);


$stmt->execute([$username]);


$user=$stmt->fetch();



if($user && password_verify($password,$user['password'])){


$_SESSION['admin']=$user['username'];

$_SESSION['role']=$user['role'];



header("Location: dashboard.php");

exit;



}else{


$error="نام کاربری یا رمز عبور اشتباه است";


}



}


?>


<!DOCTYPE html>

<html lang="fa" dir="rtl">


<head>


<meta charset="UTF-8">


<meta name="viewport" content="width=device-width, initial-scale=1.0">


<title>
L-PANEL Login
</title>


<link rel="stylesheet" href="assets/css/login.css">


</head>



<body>



<div class="login-box">


<div class="logo">


<h1>
L-PANEL
</h1>


<span>
VPN Management Panel
</span>


</div>



<?php if($error): ?>

<div class="error">

<?=$error?>

</div>

<?php endif; ?>



<form method="post">



<input

class="form-control"

name="username"

placeholder="نام کاربری"

autocomplete="username"

>



<input

class="form-control"

type="password"

name="password"

placeholder="رمز عبور"

autocomplete="current-password"

>



<button class="login-btn">

ورود به پنل

</button>



</form>



<div class="footer-text">

L-PANEL © 2026

</div>



</div>



</body>


</html>
