<!DOCTYPE html>
<html lang="fa">
<head>
    <meta charset="UTF-8">
    <title>User Login</title>
    <link rel="stylesheet" href="assets/css/login.css">
</head>
<body>

<div class="login-wrapper">
    <div class="login-card">
        <h2>User Login</h2>

        <form method="POST" action="auth-user.php">
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
            <a href="login-reseller.php">Reseller Login</a>
        </div>
    </div>
</div>

</body>
</html>
