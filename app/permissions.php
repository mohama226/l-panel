<?php


function isSuperAdmin(){

    if(
        isset($_SESSION['role'])
        &&
        $_SESSION['role']=="superadmin"
    ){
        return true;
    }

    return false;

}



function requireSuperAdmin(){

    if(!isSuperAdmin()){

        http_response_code(403);

        die(
            "Access Denied"
        );

    }

}



function hasPermission($permission){

    global $db;


    if(isSuperAdmin()){

        return true;

    }


    if(!isset($_SESSION['admin_id'])){

        return false;

    }


    $stmt=$db->prepare("
        SELECT COUNT(*)
        FROM admin_permissions
        WHERE admin_id=?
        AND permission=?
    ");


    $stmt->execute([
        $_SESSION['admin_id'],
        $permission
    ]);


    return $stmt->fetchColumn()>0;


}



function requirePermission($permission){


    if(!hasPermission($permission)){


        http_response_code(403);

        die(
            "Permission Denied"
        );


    }


}
