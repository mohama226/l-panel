<?php

require_once "../../app/auth.php";

?>

<div class="sidebar">

<h2>
L-PANEL
</h2>

<a href="/modiran/dashboard.php">
داشبورد
</a>

<?php if(isset($_SESSION['role']) && $_SESSION['role']=="superadmin"): ?>
<li>
    <a href="/modiran/admins.php">
        مدیریت مدیران
    </a>
</li>
<?php endif; ?>

<a href="/modiran/users/">
کاربران VPN
</a>

<?php if(isSuperAdmin()): ?>

<hr>

<h4>
مدیریت سیستم
</h4>

<a href="/modiran/manage/">
مدیران
</a>

<a href="/modiran/settings/panel.php">
تنظیمات
</a>

<a href="/modiran/logs.php">
لاگ مدیران
</a>

<?php endif; ?>

<a href="/modiran/logout.php">
خروج
</a>

</div>
