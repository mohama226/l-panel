<?php

session_start();


function checkLogin(){

    if(!isset($_SESSION['admin_id'])){

        header("Location: /modiran/");
        exit;

    }

}



function isSuperAdmin(){

    return isset($_SESSION['role'])
    &&
    $_SESSION['role']=="superadmin";

}



function requireSuperAdmin(){

    if(!isSuperAdmin()){

        http_response_code(403);

        die("Access Denied");

    }

}



function hasPermission($permission){


    global $db;


    if(isSuperAdmin()){

        return true;

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

        die("Permission Denied");


    }


}


?>
