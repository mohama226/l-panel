<?php
// public/dashboard.php
require_once __DIR__ . '/../app/auth.php';
require_once __DIR__ . '/../app/OcservManager.php';

auth_require();

$users = OcservManager::listUsers();
?>
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="UTF-8">
    <title>داشبورد - L-Panel</title>
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="logo">L-Panel</div>
        <ul class="menu">
            <li><a href="dashboard.php">داشبورد</a></li>
            <li><a href="servers.php">سرورها</a></li>
            <li><a href="users.php">یوزرها</a></li>
            <li><a href="resellers.php">نماینده‌ها</a></li>
            <li><a href="logout.php">خروج</a></li>
        </ul>
    </aside>
    <main class="content">
        <h1>داشبورد</h1>
        <h2>یوزرهای ocserv روی این سرور</h2>
        <table class="table">
            <thead>
            <tr>
                <th>نام کاربری</th>
            </tr>
            </thead>
            <tbody>
            <?php foreach ($users as $u): ?>
                <tr>
                    <td><?= htmlspecialchars($u) ?></td>
                </tr>
            <?php endforeach; ?>
            </tbody>
        </table>
    </main>
</div>
</body>
</html>
