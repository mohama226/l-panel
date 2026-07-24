<?php


require_once __DIR__."/session.php";


function checkLogin(){


if(!isset($_SESSION['admin'])){

header("Location: /modiran/");
exit;

}


}


?>
