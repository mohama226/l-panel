<?php

require_once "../../app/session.php";
require "../../app/database.php";
require "../../app/logger.php";
require "../../app/auth.php";
require "../../app/permissions.php";

$error = "";

if($_POST){

    $username = $_POST['username'];
    $password = $_POST['password'];

    $stmt = $db->prepare(
        "SELECT * FROM admins WHERE username=? AND status='active'"
    );

    $stmt->execute([$username]);

    $user = $stmt->fetch();

    if($user && password_verify($password,$user['password'])){

        $_SESSION['admin'] = $user['username'];
        $_SESSION['role']  = $user['role'];   // ← طبق دستور تو باقی ماند

        $db->prepare(
            "UPDATE admins SET last_login=NOW() WHERE id=?"
        )->execute([$user['id']]);

        writeLog(
            "admin.log",
            "ورود ".$user['username']
        );

        header("Location: dashboard.php");
        exit;

    } else {

        $error = "نام کاربری یا رمز اشتباه است";

    }

}

?>

<!DOCTYPE html>
<html lang="fa" dir="rtl">

<head>
<meta charset="UTF-8">
<title>L-PANEL LOGIN</title>
<link rel="stylesheet" href="../assets/css/login.css">
</head>

<body>

<div class="login-box">

<h1>L-PANEL</h1>

<?php if($error): ?>
<div class="error">
    <?=$error?>
</div>
<?php endif; ?>

<form method="post">

<input name="username"
       placeholder="نام کاربری">

<input type="password"
       name="password"
       placeholder="رمز عبور">

<button>
    ورود
</button>

</form>

</div>

</body>
</html>
