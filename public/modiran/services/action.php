<?php

require_once dirname(__DIR__,3)."/app/init.php";

require_once BASE_PATH."/app/auth.php";
require_once BASE_PATH."/app/service_manager.php";

checkLogin();

$service = $_GET['service'] ?? '';
$action  = $_GET['action'] ?? '';

serviceAction(
    $service,
    $action
);

header("Location:index.php");
exit;

