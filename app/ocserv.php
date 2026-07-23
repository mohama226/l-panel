<?php


function ocserv_request($data){


$socket="/var/run/lpanel-agent.sock";


$fp=stream_socket_client(

"unix://".$socket,

$errno,

$errstr,

3

);



if(!$fp){

return false;

}



fwrite(

$fp,

json_encode($data)

);



$result=fread($fp,4096);



fclose($fp);



return json_decode($result,true);


}




function ocserv_user_add($username,$password){


return ocserv_request([

"action"=>"add",

"username"=>$username,

"password"=>$password

]);


}




function ocserv_user_delete($username){


return ocserv_request([

"action"=>"delete",

"username"=>$username

]);


}




function ocserv_user_password($username,$password){


return ocserv_request([

"action"=>"password",

"username"=>$username,

"password"=>$password

]);


}


?>
