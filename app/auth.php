<?php


session_start();



function checkLogin(){


if(!isset($_SESSION['admin'])){


header(
"Location: /modiran/"
);

exit;


}


}



?>
