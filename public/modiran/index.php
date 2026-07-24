<?php

require_once "../../app/session.php";
require_once "../../app/database.php";
require_once "../../app/logger.php";
require_once "../../app/auth.php";

$error = "";

if($_SERVER['REQUEST_METHOD'] === 'POST'){

    $username = trim($_POST['username']);
    $password = $_POST['password'];

    $stmt = $db->prepare(
        "SELECT * FROM admins WHERE username=?"
    );

    $stmt->execute([$username]);

    $user = $stmt->fetch(PDO::FETCH_ASSOC);


    if($user && password_verify($password,$user['password'])){

        $_SESSION['admin'] = $user['username'];
        $_SESSION['role']  = $user['role'];


        writeLog(
            "admin.log",
            "ورود مدیر ".$user['username']
        );


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
<title>L-PANEL Admin</title>

<link rel="stylesheet" href="../assets/css/login.css">

</head>


<body>


<div class="login-box">


<div class="logo">

<h1>L-PANEL</h1>

<span>Admin Login</span>

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
required>


<input 
class="form-control"
type="password"
name="password"
placeholder="رمز عبور"
required>



<button class="login-btn">
ورود مدیر
</button>


</form>


</div>


</body>

</html>
