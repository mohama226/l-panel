<?php

require_once "session.php";


function checkLogin(){

    if(!isset($_SESSION['admin'])){

        header("Location:/modiran/");
        exit;

    }

}



function isSuperAdmin(){

    if(!isset($_SESSION['role'])){
        return false;
    }


    return $_SESSION['role']=="superadmin";

}




function requireSuperAdmin(){

    if(!isSuperAdmin()){

        http_response_code(403);

        die("Access Denied");

    }

}



function adminName(){

    return $_SESSION['admin'] ?? '';

}

?>
