<?php

session_start();


function checkLogin(){

if(!isset($_SESSION['admin'])){

header("Location:/modiran/");
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

die("Access Denied");

}

}

?>
