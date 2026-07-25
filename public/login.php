<?php
session_start();
require_once __DIR__ . '/../system/config.php';
require_once __DIR__ . '/../app/Core/Auth.php';

if (Auth::check()) {
    header("Location: /dashboard");
    exit;
}

$error = $_GET['error'] ?? null;
?>
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="UTF-8">
    <title>ورود به پنل مدیریت</title>
    <link rel="stylesheet" href="/assets/css/login.css">
</head>
<body>

<div class="login-box">
    <h2>ورود مدیر</h2>

    <?php if ($error): ?>
        <div class="error"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>

    <form method="POST" action="/auth/login">
        <label>نام کاربری</label>
        <input type="text" name="username" required>

        <label>رمز عبور</label>
        <input type="password" name="password" required>

        <button type="submit">ورود</button>
    </form>
</div>

</body>
</html>
