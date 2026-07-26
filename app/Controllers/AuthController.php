<?php

declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\CSRF;
use App\Core\Response;
use App\Core\Auth;

class AuthController extends Controller
{
    public function login(): void
    {
        $this->view('auth/login', [
            'csrf' => CSRF::token()
        ]);
    }

    public function authenticate(): void
    {
        if (!CSRF::verify($_POST['_token'] ?? '')) {
            Response::abort(403);
        }

        // دریافت ورودی‌ها
        $username = $_POST['username'] ?? '';
        $password = $_POST['password'] ?? '';

        // جستجوی ادمین
        $db = new \App\Core\Database();
        $stmt = $db->connection()->prepare(
            "SELECT * FROM admins WHERE username=? LIMIT 1"
        );
        $stmt->execute([$username]);
        $admin = $stmt->fetch();

        // بررسی رمز
        if (!$admin || !password_verify($password, $admin['password'])) {
            Response::redirect('/login');
        }

        // ست کردن سشن‌ها
        $_SESSION['admin_id'] = $admin['id'];
        $_SESSION['admin_username'] = $admin['username'];

        // ریدایرکت
        header("Location: /dashboard");
        exit;
    }

    public function logout(): void
    {
        session_destroy();
        header("Location: /login");
        exit;
    }
}
