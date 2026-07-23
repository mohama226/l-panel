<?php


require "../../../app/auth.php";

checkLogin();


require "../../../app/database.php";



$msg="";



if($_POST){



$prefix=$_POST['prefix'];

$count=$_POST['count'];

$expire=$_POST['expire_date'];

$volume=$_POST['total_gb'];



for($i=1;$i<=$count;$i++){


$username=$prefix.str_pad(
$i,
3,
"0",
STR_PAD_LEFT
);



$password=substr(
bin2hex(random_bytes(5)),
0,
8
);



$hash=password_hash(
$password,
PASSWORD_DEFAULT
);



$stmt=$db->prepare(

"INSERT INTO users
(username,password,expire_date,total_gb)
VALUES
(?,?,?,?)"

);



$stmt->execute([

$username,
$hash,
$expire,
$volume

]);


}



$msg=$count." کاربر ساخته شد";



}



include "../../includes/header.php";

include "../../includes/sidebar.php";


?>



<div class="card">


<h2>

افزودن گروهی کاربران

</h2>



<p>

<?=$msg?>

</p>



<form method="post">



<input class="form-control"

name="prefix"

placeholder="پیشوند مثال: user">



<input class="form-control"

name="count"

placeholder="تعداد کاربران">



<input class="form-control"

type="date"

name="expire_date">



<input class="form-control"

name="total_gb"

placeholder="حجم GB">



<button class="login-btn">

ساخت کاربران

</button>


</form>



</div>



<?php

include "../../includes/footer.php";

?>
