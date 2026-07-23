<?php


require "../../../app/auth.php";

checkLogin();



require "../../../app/database.php";



$id=$_GET['id'];



$stmt=$db->prepare(

"DELETE FROM users WHERE id=?"

);



$stmt->execute([$id]);



header("Location: /modiran/users");

exit;


?>
