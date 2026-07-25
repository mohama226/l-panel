<?php

require_once dirname(__DIR__,2) . "/app/init.php";
require_once BASE_PATH . "/app/database.php";

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

$error = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $username = trim($_POST['username']);
    $password = trim($_POST['password']);

    $stmt = $db->prepare("SELECT * FROM users WHERE username=? LIMIT 1");
    $stmt->execute([$username]);
    $user = $stmt->fetch();

    if ($user && password_verify($password, $user['password'])) {

        $_SESSION['user']     = $user['username'];
        $_SESSION['user_id']  = $user['id'];

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
<title>ورود کاربران VPN</title>
<link rel="stylesheet" href="/assets/css/user-login.css">
</head>

<body>

<div class="login-container">

    <div class="login-box">

        <h1 class="title">ورود کاربران VPN</h1>
        <h3 class="subtitle">L‑PANEL USER LOGIN</h3>

        <?php if($error): ?>
        <div class="error-box"><?= $error ?></div>
        <?php endif; ?>

        <form method="post">

            <div class="input-group">
                <label>نام کاربری</label>
                <input name="username" required>
            </div>

            <div class="input-group">
                <label>رمز عبور</label>
                <input type="password" name="password" required>
            </div>

            <button class="login-btn">ورود به حساب</button>

        </form>

    </div>

</div>

</body>
</html>
