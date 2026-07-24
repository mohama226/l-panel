<?php


function getServices()
{

    $output = [];

    exec(
        "systemctl list-units --type=service --all --no-pager --no-legend",
        $lines
    );


    foreach($lines as $line){


        $line = trim($line);


        if(empty($line)){
            continue;
        }


        $parts = preg_split('/\s+/', $line);


        if(count($parts) < 4){
            continue;
        }


        $name = $parts[0];


        /*
            حذف خطوط خراب مثل:
            ● httpd-init.service
        */

        if($name=="●"){
            continue;
        }


        if(
            !str_ends_with(
                $name,
                ".service"
            )
        ){
            continue;
        }



        $output[]=[

            "name"=>str_replace(
                ".service",
                "",
                $name
            ),

            "load"=>$parts[1] ?? '',

            "active"=>$parts[2] ?? '',

            "sub"=>$parts[3] ?? ''

        ];


    }


    return $output;

}




function serviceAction(
    $service,
    $action
){


    $allowed=[

        "ocserv",
        "httpd",
        "php-fpm",
        "mariadb",
        "lpanel-agent",
        "sshd",
        "crond"

    ];


    if(!in_array($service,$allowed)){

        die(
            "Service not allowed"
        );

    }



    $actions=[

        "start",
        "stop",
        "restart"

    ];



    if(!in_array($action,$actions)){

        die(
            "Action not allowed"
        );

    }



    exec(
        "sudo systemctl $action $service"
    );


}


?>
