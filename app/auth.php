<?php

require_once __DIR__."/session.php";


function checkLogin(){


if(!isset($_SESSION['admin'])){


header(
"Location: /modiran/"
);

exit;


}


}



function isSuperAdmin(){


return (

isset($_SESSION['role'])

&&

$_SESSION['role']=="superadmin"

);


}



function requireSuperAdmin(){


if(!isSuperAdmin()){


die(
"Access Denied"
);


}


}



function hasPermission($permission){


global $db;


if(isSuperAdmin()){

return true;

}



$stmt=$db->prepare(
"
SELECT COUNT(*)
FROM admin_permissions p

JOIN admins a

ON a.id=p.admin_id

WHERE a.username=?

AND p.permission=?

"
);



$stmt->execute([

$_SESSION['admin'],

$permission

]);



return $stmt->fetchColumn()>0;


}

?>
