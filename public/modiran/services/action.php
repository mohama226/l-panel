<?php


require "../../../app/auth.php";
require "../../../app/service_manager.php";


checkLogin();



$service=$_GET['service'] ?? '';

$action=$_GET['action'] ?? '';



serviceAction(
    $service,
    $action
);



header(
"Location:index.php"
);

exit;
