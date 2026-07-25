<?php
require_once __DIR__ . '/../app/db.php';

$error = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $pdo = db();
    $u = trim($_POST['username']);
    $p = trim($_POST['password']);

    $stmt = $pdo->prepare("SELECT * FROM users WHERE username = ? LIMIT 1");
    $stmt->execute([$u]);
    $user = $stmt->fetch();

    if ($user && password_verify($p, $user['password'])) {
        session_start();
        $_SESSION['user_id'] = $user['id'];
        header("Location: user-dashboard.php");
        exit;
    } else {
        $error = "Invalid user login.";
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Login</title>
    <link rel="stylesheet" href="assets/css/login.css">
</head>
<body>
<div class="login-container">
    <div class="login-title">User Login</div>

    <?php if ($error): ?>
        <div class="error-box"><?= $error ?></div>
    <?php endif; ?>

    <form method="post">
        <label>Username</label>
        <input type="text" name="username" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <button type="submit">Login</button>
    </form>
</div>
</body>
</html>
