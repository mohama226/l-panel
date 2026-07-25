<?php
// app/auth.php
require_once __DIR__ . '/db.php';

session_start();

function auth_login($username, $password)
{
    $pdo = db();
    $stmt = $pdo->prepare('SELECT id, username, password, role FROM admins WHERE username = ? LIMIT 1');
    $stmt->execute([$username]);
    $user = $stmt->fetch();

    if ($user && password_verify($password, $user['password'])) {
        $_SESSION['admin_id'] = $user['id'];
        $_SESSION['admin_username'] = $user['username'];
        $_SESSION['admin_role'] = $user['role'];
        return true;
    }

    return false;
}

function auth_check()
{
    return isset($_SESSION['admin_id']);
}

function auth_require()
{
    if (!auth_check()) {
        header('Location: login.php');
        exit;
    }
}

function auth_logout()
{
    session_destroy();
    header('Location: login.php');
    exit;
}
