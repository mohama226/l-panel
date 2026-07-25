<?php

require_once dirname(__DIR__,2) . "/app/init.php";
require_once BASE_PATH . "/app/auth.php";

// بررسی لاگین
checkLogin();

// هدایت به داشبورد
header("Location: dashboard.php");
exit;
