<?php


function isSuperAdmin(){

    return isset($_SESSION['role'])
    &&
    $_SESSION['role']=="superadmin";

}



function requireSuperAdmin(){

    if(!isSuperAdmin()){

        die("Access Denied");

    }

}



function hasPermission($permission){


    if(isSuperAdmin()){

        return true;

    }


    if(!isset($_SESSION['permissions'])){

        return false;

    }


    $list=json_decode(
        $_SESSION['permissions'],
        true
    );


    return in_array(
        $permission,
        $list
    );


}

?>
