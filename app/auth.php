<?php

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

function checkLogin() {

    // اگر لاگین نیست → بفرست به صفحه لاگین واقعی
    if (!isset($_SESSION['admin'])) {
        header("Location: /modiran/login.php");
        exit;
    }
}

function logout() {
    session_destroy();
    header("Location: /modiran/login.php");
    exit;
}
