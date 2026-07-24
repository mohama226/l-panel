<?php


function getTrafficChart($db)
{


$data = [];



$sql = "

SELECT

DATE(created_at) as day,

SUM(download_gb) as download,

SUM(upload_gb) as upload


FROM traffic_logs


WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)


GROUP BY DATE(created_at)


ORDER BY day ASC

";



$stmt=$db->query($sql);



while($row=$stmt->fetch(PDO::FETCH_ASSOC)){


$data[]=[

"day"=>$row['day'],

"download"=>(float)$row['download'],

"upload"=>(float)$row['upload']

];


}



return $data;


}
