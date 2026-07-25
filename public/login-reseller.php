<?php
require_once __DIR__ . '/../app/db.php';

$error = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $pdo = db();
    $u = trim($_POST['username']);
    $p = trim($_POST['password']);

    $stmt = $pdo->prepare("
        SELECT r.*, a.password 
        FROM resellers r 
        JOIN admins a ON r.admin_id = a.id 
        WHERE a.username = ? LIMIT 1
    ");
    $stmt->execute([$u]);
    $reseller = $stmt->fetch();

    if ($reseller && password_verify($p, $reseller['password'])) {
        session_start();
        $_SESSION['reseller_id'] = $reseller['id'];
        header("Location: reseller-dashboard.php");
        exit;
    } else {
        $error = "Invalid reseller login.";
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reseller Login</title>
    <link rel="stylesheet" href="assets/css/login.css">
</head>
<body>
<div class="login-container">
    <div class="login-title">Reseller Login</div>

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
