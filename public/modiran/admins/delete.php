<?php


require "../../../app/database.php";


$id=$_GET['id'];


$db->prepare(
"DELETE FROM admins WHERE id=?"
)
->execute([$id]);


header(
"Location:index.php"
);
