<?php


require "../../../app/auth.php";
requireSuperAdmin();


require "../../../app/database.php";


$id=$_GET['id'];



if($id){


$db->prepare(

"DELETE FROM admins WHERE id=?"

)
->execute([$id]);


}



header(
"Location:index.php"
);

exit;


?>
