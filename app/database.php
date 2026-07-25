<?php

/**
 * اتصال استاندارد PDO برای کل پروژه L-PANEL
 * این فایل تنها مرجع اتصال دیتابیس است.
 */

if (!defined('BASE_PATH')) {
    define('BASE_PATH', dirname(__DIR__));
}

$dbHost = "localhost";
$dbName = "lpanel";
$dbUser = "lpanel";        // یوزری که ساختی
$dbPass = "StrongPass123"; // پسوردی که ساختی

try {

    $db = new PDO(
        "mysql:host={$dbHost};dbname={$dbName};charset=utf8",
        $dbUser,
        $dbPass,
        [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_PERSISTENT         => true
        ]
    );

} catch (Exception $e) {

    // نمایش خطا برای دیباگ
    die(
        "<pre style='direction:ltr;text-align:left;background:#fee;padding:10px;border:1px solid #f00;'>
        DATABASE CONNECTION ERROR:
        {$e->getMessage()}
        </pre>"
    );
}

?>
