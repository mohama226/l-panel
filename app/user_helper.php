<?php


function remaining_days($expire){


$now=time();

$end=strtotime($expire);



$diff=$end-$now;


if($diff<=0){

return 0;

}



return ceil($diff/(60*60*24));


}



function volume_percent($used,$total){


if($total<=0){

return 0;

}


$p=($used/$total)*100;


if($p>100){

$p=100;

}


return round($p);



}

?>
