<?php


function hasPermission($permission){


global $db;


if(
isset($_SESSION['role'])
&&
$_SESSION['role']=="superadmin"
){

    return true;

}



if(!isset($_SESSION['admin_id'])){

    return false;

}



$stmt=$db->prepare(

"
SELECT COUNT(*)
FROM admin_permissions
WHERE admin_id=?
AND permission=?
"

);



$stmt->execute([

$_SESSION['admin_id'],
$permission

]);



return $stmt->fetchColumn()>0;



}



function requirePermission($permission){


if(!hasPermission($permission)){


die("Permission Denied");


}


}


?>
