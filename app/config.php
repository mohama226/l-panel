<?php
// app/config.php

// تنظیمات دیتابیس
define('DB_HOST', 'localhost');
define('DB_NAME', 'lpanel');
define('DB_USER', 'lpanel_user');
define('DB_PASS', 'strong_password_here');
define('DB_CHARSET', 'utf8mb4');

// تنظیمات عمومی پنل
define('APP_NAME', 'L-Panel PHP');
define('APP_URL', 'http://your-domain.com'); // بعداً تغییر بده
define('APP_TIMEZONE', 'UTC');

// مسیر ocserv روی سرور
define('OCSERV_CONFIG', '/etc/ocserv/ocserv.conf');
define('OCSERV_PASSWD', '/etc/ocserv/ocpasswd');
define('OCSERV_BIN', '/usr/sbin/ocpasswd');

// فعال کردن نمایش خطا در حالت توسعه
ini_set('display_errors', 1);
error_reporting(E_ALL);

date_default_timezone_set(APP_TIMEZONE);
