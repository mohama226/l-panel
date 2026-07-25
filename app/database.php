<?php

if (!defined('BASE_PATH')) {
    define('BASE_PATH', dirname(__DIR__));
}

$dbHost = "localhost";
$dbName = "lpanel";
$dbUser = "lpanel";
$dbPass = "StrongPass123";

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

    die(
        "<pre style='direction:ltr;text-align:left;background:#fee;padding:10px;border:1px solid #f00;'>
        DATABASE CONNECTION ERROR:
        {$e->getMessage()}
        </pre>"
    );
}

?>
