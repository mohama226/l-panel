<?php

require_once dirname(__DIR__,2) . "/app/init.php";
require_once BASE_PATH . "/app/auth.php";

checkLogin();

header("Location: /modiran/dashboard.php");
exit;
