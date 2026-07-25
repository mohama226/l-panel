<?php
session_start();
if (!isset($_SESSION['admin'])) {
    header("Location: login-admin.php");
    exit;
}
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
</head>
<body>
<h1>Welcome Admin</h1>
<p>Dashboard is working.</p>
</body>
</html>
