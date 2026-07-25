<?php
session_start();

$username = $_POST['username'];
$password = $_POST['password'];

// یوزر و پسورد ادمین را از فایل کانفیگ بخوان
$admin_user = "admin";
$admin_pass = "admin123"; // بعداً از دیتابیس می‌گیریم

if ($username === $admin_user && $password === $admin_pass) {
    $_SESSION['admin'] = true;
    header("Location: dashboard.php");
    exit;
} else {
    echo "Wrong username or password";
}
?>
