<?php

require "../../../app/database.php";


$id=$_GET['id'];


if($_POST){


$db->prepare(

"UPDATE admins 
SET role=?,status=?
WHERE id=?"

)
->execute([

$_POST['role'],
$_POST['status'],
$id

]);


header(
"Location:index.php"
);

exit;

}



$admin=$db->query(

"SELECT * FROM admins WHERE id=$id"

)->fetch();


?>


<form method="post">


<select name="role">

<option>
admin
</option>

<option>
support
</option>

<option>
reseller
</option>


</select>



<select name="status">

<option>
active
</option>


<option>
disabled
</option>


</select>



<button>
Update
</button>


</form>
