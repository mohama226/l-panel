<?php

class AuthController
{
    public function login()
    {
        session_start();
        require_once __DIR__ . '/../../system/database.php';

        $username = $_POST['username'] ?? '';
        $password = $_POST['password'] ?? '';

        $db = Database::connect();

        $stmt = $db->prepare("SELECT * FROM users WHERE username = :u LIMIT 1");
        $stmt->execute(['u' => $username]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$user || !password_verify($password, $user['password'])) {
            header("Location: /login.php?error=نام کاربری یا رمز اشتباه است");
            exit;
        }

        $_SESSION['user_id'] = $user['id'];
        $_SESSION['role'] = $user['role'];

        header("Location: /dashboard");
        exit;
    }

    public function logout()
    {
        session_start();
        session_destroy();
        header("Location: /login.php");
        exit;
    }
}
