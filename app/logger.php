<?php


require_once __DIR__.'/database.php';



function admin_log($action,$target,$description){


if(!isset($_SESSION['admin'])){
    return;
}


$stmt=$db->prepare("
INSERT INTO admin_logs
(admin,action,target_user,description)
VALUES(?,?,?,?)
");


$stmt->execute([

$_SESSION['admin'],
$action,
$target,
$description

]);


}

?>
