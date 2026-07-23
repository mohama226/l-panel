<?php


function checkLogin(){

if(!isset($_SESSION['admin'])){

header("Location: login.php");

exit;

}

}


?>
