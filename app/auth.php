<?php

session_start();


function checkLogin(){

    if(!isset($_SESSION['admin_id'])){

        header("Location: /modiran/");
        exit;

    }

}



function isSuperAdmin(){

    return (
        isset($_SESSION['role']) &&
        $_SESSION['role']=="superadmin"
    );

}



function requireSuperAdmin(){

    if(!isSuperAdmin()){

        die("Access Denied");

    }

}



function currentAdmin(){

    return $_SESSION['admin'] ?? null;

}



function currentRole(){

    return $_SESSION['role'] ?? null;

}


?>
