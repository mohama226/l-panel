<?php

class Auth
{
    public static function check()
    {
        return isset($_SESSION['user_id']);
    }

    public static function requireAdmin()
    {
        if (!self::check()) {
            header("Location: /login.php");
            exit;
        }
    }
}
