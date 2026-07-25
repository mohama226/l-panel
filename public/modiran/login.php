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

    $stmt = $db->prepare("SELECT * FROM admins WHERE username=? LIMIT 1");
    $stmt->execute([$username]);
    $user = $stmt->fetch();

    if ($user && password_verify($password, $user['password'])) {

        $_SESSION['admin']     = $user['username'];
        $_SESSION['role']      = $user['role'];
        $_SESSION['admin_id']  = $user['id'];
        $_SESSION['login_time'] = time();

        // مسیر صحیح داشبورد
        header("Location: /modiran/dashboard.php");
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
<title>L-PANEL ADMIN</title>
<link rel="stylesheet" href="/assets/css/login.css">
</head>

<body>

<div class="login-box">

<h1>L-PANEL</h1>
<h3>Admin Panel</h3>

<?php if($error): ?>
<div class="error"><?= $error ?></div>
<?php endif; ?>

<form method="post">
    <input name="username" placeholder="Username" required>
    <input type="password" name="password" placeholder="Password" required>
    <button type="submit">ورود</button>
</form>

</div>

</body>
</html>
