<?php


if(session_status() === PHP_SESSION_NONE){

session_start();

}



function checkUser(){


if(!isset($_SESSION['vpn_user'])){


header("Location: /users");

exit;


}


}


?>
