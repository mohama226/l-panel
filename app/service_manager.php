<?php


function getServices(){


    $output=[];


    exec(
        "systemctl list-units --type=service --all --no-pager --no-legend",
        $lines
    );


    foreach($lines as $line){


        $parts=preg_split('/\s+/',trim($line));


        if(isset($parts[0])){


            $output[]=[

                "name"=>$parts[0],

                "load"=>$parts[1] ?? '',

                "active"=>$parts[2] ?? '',

                "sub"=>$parts[3] ?? ''

            ];


        }

    }


    return $output;

}



function serviceAction($service,$action){


    $allow=[
        "start",
        "stop",
        "restart",
        "reload"
    ];


    if(!in_array($action,$allow)){

        return false;

    }


    $service=escapeshellarg($service);


    exec(
        "systemctl $action $service"
    );


    return true;

}
