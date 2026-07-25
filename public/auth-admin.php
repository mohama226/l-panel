<?php
session_start();

// یوزر و پسورد ادمین ثابت (بعداً می‌ذاریم تو دیتابیس)
$admin_user = "admin";
$admin_pass = "admin123"; // اینو خودت تغییر بده

$username = $_POST['username'];
$password = $_POST['password'];

if ($username === $admin_user && $password === $admin_pass) {
    $_SESSION['admin'] = true;
    header("Location: dashboard.php");
    exit;
} else {
    echo "Wrong username or password";
}
?>
