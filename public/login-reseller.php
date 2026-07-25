<!DOCTYPE html>
<html lang="fa">
<head>
    <meta charset="UTF-8">
    <title>Reseller Login</title>
    <link rel="stylesheet" href="assets/css/login.css">
</head>
<body>

<div class="login-box">
    <h2>Reseller Login</h2>

    <form method="POST" action="auth-reseller.php">
        <div class="input-group">
            <label>Username</label>
            <input type="text" name="username" required>
        </div>

        <div class="input-group">
            <label>Password</label>
            <input type="password" name="password" required>
        </div>

        <button class="btn">Login</button>
    </form>

    <div class="switch-link">
        <a href="login-admin.php">Admin Login</a> |
        <a href="login-user.php">User Login</a>
    </div>
</div>

</body>
</html>
