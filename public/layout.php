<?php
session_start();
require_once __DIR__ . '/../system/config.php';
require_once __DIR__ . '/../app/Core/Auth.php';

Auth::requireAdmin();

$page_title = $page_title ?? 'L-PANEL';
$content    = $content    ?? '';
?>
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="UTF-8">
    <title><?= htmlspecialchars($page_title) ?></title>
    <link rel="stylesheet" href="/assets/css/panel.css?v=<?=time()?>">
</head>
<body>

<div class="app">
    <aside class="sidebar">
        <div class="logo">
            <span class="logo-icon">LP</span>
            <span class="logo-text">L-PANEL</span>
        </div>
        <nav class="menu">
            <a href="/dashboard" class="menu-item">داشبورد</a>
            <a href="/servers" class="menu-item">سرورها</a>
            <a href="/users" class="menu-item">کاربران VPN</a>
            <a href="/resellers" class="menu-item">نماینده‌ها</a>
            <a href="/auth/logout" class="menu-item logout">خروج</a>
        </nav>
    </aside>

    <div class="main">
        <header class="topbar">
            <div class="top-title"><?= htmlspecialchars($page_title) ?></div>
            <div class="top-actions">
                <button id="toggle-theme" class="btn-secondary">تم</button>
            </div>
        </header>

        <main class="content">
            <?= $content ?>
        </main>
    </div>
</div>

<script src="/assets/js/panel.js?v=<?=time()?>"></script>
</body>
</html>
