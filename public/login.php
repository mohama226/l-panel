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

$error="Invalid Login";

}


}

?>


<!DOCTYPE html>
<html>
<head>
<title>L-PANEL Login</title>
</head>

<body>

<h2>L-PANEL</h2>


<form method="post">

<input name="username" placeholder="Username">

<br>

<input type="password" name="password" placeholder="Password">

<br>

<button type="submit">
Login
</button>

</form>


<?php echo $error; ?>


</body>

</html>
