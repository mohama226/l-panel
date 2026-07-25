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
    <link rel="stylesheet" href="/assets/css/login.css?v=<?=time()?>">
    <script src="/assets/js/login.js" defer></script>
</head>
<body>

<div class="login-container">
    <div class="login-box">
        <h2 class="title">ورود به پنل مدیریت</h2>

        <?php if ($error): ?>
            <div class="error"><?= htmlspecialchars($error) ?></div>
        <?php endif; ?>

        <form method="POST" action="/auth/login" class="login-form">
            <div class="input-group">
                <label>نام کاربری</label>
                <input type="text" name="username" required>
            </div>

            <div class="input-group">
                <label>رمز عبور</label>
                <input type="password" name="password" required>
            </div>

            <button type="submit" class="login-btn">ورود</button>
        </form>
    </div>
</div>

</body>
</html>
