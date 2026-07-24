<?php

require_once __DIR__.'/session.php';



function checkLogin(){

    if(
        !isset($_SESSION['admin'])
    ){

        header(
            "Location: index.php"
        );

        exit;

    }

}


function logout(){

    session_destroy();

    header(
        "Location: index.php"
    );

    exit;
}

?>
