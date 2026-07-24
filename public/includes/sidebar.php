<?php

require_once dirname(__DIR__,2)."/app/init.php";
require_once BASE_PATH."/app/auth.php";

?>

<!DOCTYPE html>
<html lang="fa" dir="rtl">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">

<title>L-PANEL</title>

<link rel="stylesheet" href="/assets/css/style.css">
<link rel="stylesheet" href="/assets/css/admin.css">
<link rel="stylesheet" href="/assets/css/services.css">

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

</head>


<body>


<div class="layout">


<aside class="sidebar">


<h2>
L-PANEL
</h2>



<a href="/modiran/dashboard.php">
🏠 داشبورد
</a>



<a href="/modiran/users/">
👥 کاربران VPN
</a>



<hr>



<h3>
مدیریت سیستم
</h3>



<a href="/modiran/admins.php">
👑 مدیران
</a>



<a href="/modiran/logs.php">
📋 لاگ مدیران
</a>



<a href="/modiran/services/">
⚙️ تنظیمات سرویس‌ها
</a>



<a href="/modiran/logout.php">
🚪 خروج
</a>



</aside>
