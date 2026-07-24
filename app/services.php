<?php


function getServices(){


    $output=[];


    exec("systemctl list-units --type=service --all --no-pager --no-legend",$lines);


    foreach($lines as $line){


        preg_match(
            '/^([a-zA-Z0-9\-\@\.]+)\s+loaded\s+(\w+)\s+(\w+)\s+(.*)$/',
            trim($line),
            $m
        );


        if(isset($m[1])){


            $name=$m[1];


            $active=$m[3];


            $uptime=shell_exec(
                "systemctl show $name --property=ActiveEnterTimestamp"
            );


            $output[]=[

                "name"=>$name,

                "status"=>$active,

                "uptime"=>str_replace(
                    "ActiveEnterTimestamp=",
                    "",
                    trim($uptime)
                )

            ];

        }

    }


    return $output;


}



function serviceAction($service,$action){


    $allowed=[
        "start",
        "stop",
        "restart"
    ];


    if(!in_array($action,$allowed)){
        return false;
    }


    exec(
        "sudo systemctl $action ".escapeshellarg($service)
    );


    return true;

}
