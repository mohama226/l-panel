<?php


function ocserv_user_add($username,$password){


$file="/etc/ocserv/ocpasswd";


$cmd="echo '$password' | ocpasswd -c $file $username";


exec($cmd,$out,$status);



return $status===0;


}



function ocserv_user_delete($username){


$file="/etc/ocserv/ocpasswd";


$cmd="ocpasswd -c $file -d $username";


exec($cmd,$out,$status);



return $status===0;


}



function ocserv_user_password($username,$password){



$file="/etc/ocserv/ocpasswd";


$cmd="echo '$password' | ocpasswd -c $file $username";


exec($cmd,$out,$status);



return $status===0;


}


?>
