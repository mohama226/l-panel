<?php

require "../app/database.php";


$error="";


if($_POST){


$username=$_POST['username'];

$password=$_POST['password'];



$stmt=$db->prepare(
"SELECT * FROM admins WHERE username=?"
);


$stmt->execute([$username]);


$user=$stmt->fetch();

var_dump($user);
exit;

if($user && password_verify($password,$user['password'])){


$_SESSION['admin']=$user;


header("Location: dashboard.php");

exit;


}

else{


$error="Login failed";


}



}


?>


<!DOCTYPE html>

<html dir="rtl">

<head>

<title>L-PANEL</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">


</head>


<body class="bg-dark">


<div class="container mt-5">


<div class="card p-4">


<h3>
ورود مدیر
</h3>


<form method="post">


<input class="form-control mb-3"
name="username"
placeholder="Username">


<input class="form-control mb-3"
type="password"
name="password"
placeholder="Password">


<button class="btn btn-primary">

ورود

</button>


</form>


<p class="text-danger">

<?=$error?>

</p>


</div>


</div>


</body>

</html>
