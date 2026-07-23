<?php


function checkUserLogin(){


session_start();


if(!isset($_SESSION['vpn_user'])){


header("Location: /users");

exit;


}



}


?>
