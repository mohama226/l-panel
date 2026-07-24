<?php


require "../../../app/database.php";
require "../../../app/auth.php";
require "../../../app/permissions.php";


checkLogin();

requireSuperAdmin();



$id=$_GET['id'] ?? null;



if(!$id){

die("Invalid ID");

}



if($id == $_SESSION['admin_id']){

die("Cannot delete yourself");

}



$stmt=$db->prepare("
DELETE FROM admins
WHERE id=?
");


$stmt->execute([$id]);



header("Location:index.php");

exit;
