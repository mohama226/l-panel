<?php

require "../../../app/auth.php";

checkLogin();

require "../../../app/database.php";


$msg="";


if($_POST){


$username=$_POST['username'];

$password=$_POST['password'];

$expire=$_POST['expire_date'];

$volume=$_POST['total_gb'];



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



$msg="کاربر با موفقیت ساخته شد";


}



include "../../includes/header.php";

include "../../includes/sidebar.php";

?>


<div class="container">


<div class="page-title">

افزودن کاربر VPN

</div>



<div class="panel-card">



<?php if($msg): ?>

<div class="success-message">

<?=$msg?>

</div>

<?php endif; ?>




<form method="post">



<div class="grid-form">


<div class="form-group">

<label>
نام کاربری
</label>

<input 
class="form-input"
name="username"
placeholder="نام کاربری">


</div>





<div class="form-group">

<label>
رمز عبور
</label>

<input 
class="form-input"
name="password"
placeholder="رمز عبور">


</div>





<div class="form-group">

<label>
تاریخ انقضا
</label>

<input 
class="form-input"
type="date"
name="expire_date">


</div>





<div class="form-group">

<label>
حجم مجاز (GB)
</label>

<input 
class="form-input"
name="total_gb"
placeholder="مثال 50">


</div>


</div>



<br>


<button class="btn">

ذخیره کاربر

</button>



</form>


</div>


</div>



<?php

include "../../includes/footer.php";

?>
