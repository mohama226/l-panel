<?php


function gregorian_to_jalali($gy,$gm,$gd){

    $g_d_m=array(
        0,
        31,
        59,
        90,
        120,
        151,
        181,
        212,
        243,
        273,
        304,
        334
    );


    if($gy > 1600){

        $jy=979;

        $gy-=1600;

    }else{

        $jy=0;

        $gy-=621;

    }



    $gy2=($gm>2)?($gy+1):$gy;


    $days=(365*$gy)
    +(int)(($gy2+3)/4)
    -(int)(($gy2+99)/100)
    +(int)(($gy2+399)/400)
    -80
    +$gd
    +$g_d_m[$gm-1];



    $jy+=33*(int)($days/12053);

    $days%=12053;



    $jy+=4*(int)($days/1461);

    $days%=1461;



    if($days>365){

        $jy+=(int)(($days-1)/365);

        $days=($days-1)%365;

    }



    if($days<186){

        $jm=1+intdiv($days,31);

        $jd=1+($days%31);

    }else{

        $jm=7+intdiv($days-186,30);

        $jd=1+(($days-186)%30);

    }



    return $jy."/".$jm."/".$jd;

}



function jalali_date($date){


if(!$date){

return "-";

}



$parts=explode("-",$date);



return gregorian_to_jalali(

intval($parts[0]),

intval($parts[1]),

intval($parts[2])

);


}

?>
