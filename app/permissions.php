<?php

function isSuperAdmin(){

    if(!isset($_SESSION['role'])){
        return false;
    }

    return $_SESSION['role'] === 'superadmin';
}



function isAdmin(){

    if(!isset($_SESSION['role'])){
        return false;
    }

    return in_array(
        $_SESSION['role'],
        [
            'admin',
            'superadmin'
        ]
    );
}



function requireSuperAdmin(){

    if(!isSuperAdmin()){

        header(
            "Location: dashboard.php"
        );

        exit;
    }
}


function requireAdmin(){

    if(!isAdmin()){

        header(
            "Location: index.php"
        );

        exit;
    }

}

?>
