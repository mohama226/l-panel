<?php
// public/login.php
require_once __DIR__ . '/../app/auth.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username'] ?? '');
    $password = trim($_POST['password'] ?? '');

    if (auth_login($username, $password)) {
        header('Location: dashboard.php');
        exit;
    } else {
        $error = 'نام کاربری یا رمز عبور اشتباه است.';
    }
}
?>
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="UTF-8">
    <title>ورود - L-Panel</title>
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="auth-body">
<div class="auth-container">
    <h1>ورود به پنل</h1>
    <?php if (!empty($error)): ?>
        <div class="alert alert-error"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>
    <form method="post">
        <label>نام کاربری</label>
        <input type="text" name="username" required>

        <label>رمز عبور</label>
        <input type="password" name="password" required>

        <button type="submit">ورود</button>
    </form>
</div>
</body>
</html>
