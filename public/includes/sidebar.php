<div class="sidebar">

    <div class="logo">
        L-PANEL
    </div>

    <a href="/modiran/dashboard.php">
        داشبورد
    </a>

    <a href="/users/">
        کاربران VPN
    </a>

    <a href="/modiran/logs.php">
        لاگ سیستم
    </a>

    <a href="/logout.php">
        خروج
    </a>

</div>


<div class="content">

<?php if(isSuperAdmin()): ?>

    <li>
        <a href="/modiran/manage/">
            مدیریت مدیران
        </a>
    </li>

    <li>
        <a href="/modiran/settings/panel.php">
            تنظیمات پنل
        </a>
    </li>

    <li>
        <a href="/modiran/settings/backup.php">
            بکاپ
        </a>
    </li>

<?php endif; ?>

</div>
