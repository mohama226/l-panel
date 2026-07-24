<?php


session_start();



function checkLogin(){


if(
!isset($_SESSION['admin'])
){

header(
"Location: /modiran/"
);

exit;

}



}




function logout(){

session_destroy();


header(
"Location: /modiran/"
);

exit;


}
