<?php


require "../../../app/database.php";
require "../../../app/auth.php";
require "../../../app/permissions.php";
require "../../../app/services.php";


checkLogin();


if(isset($_POST['action'])){


    serviceAction(
        $_POST['service'],
        $_POST['action']
    );


    header(
        "Location:index.php"
    );

    exit;

}


$services=getServices();



include "../../includes/header.php";
include "../../includes/sidebar.php";


?>


<div class="main">


<div class="service-container">


<h1>
⚙️ مدیریت سرویس‌های سرور
</h1>



<input 
id="serviceSearch"
type="text"
placeholder="جستجوی سرویس..."
>



<table id="serviceTable">


<thead>

<tr>

<th>
سرویس
</th>

<th>
وضعیت
</th>


<th>
آپتایم
</th>


<th>
عملیات
</th>


</tr>


</thead>



<tbody>


<?php foreach($services as $s): ?>


<tr>


<td>
<?=$s['name']?>
</td>



<td>


<?php if($s['status']=="running"): ?>


<span class="service-on">
فعال
</span>


<?php else: ?>


<span class="service-off">
متوقف
</span>


<?php endif; ?>


</td>




<td>

<?=$s['uptime'] ?: "نامشخص"?>

</td>



<td>


<form method="post">


<input 
type="hidden"
name="service"
value="<?=$s['name']?>"
>


<button name="action" value="start" class="start">
Start
</button>


<button name="action" value="restart" class="restart">
Restart
</button>


<button name="action" value="stop" class="stop">
Stop
</button>


</form>


</td>


</tr>


<?php endforeach; ?>


</tbody>


</table>


</div>


</div>



<script>

document
.getElementById("serviceSearch")
.addEventListener(
"keyup",
function(){

let value=this.value.toLowerCase();


document
.querySelectorAll("#serviceTable tbody tr")
.forEach(
row=>{

row.style.display=
row.innerText
.toLowerCase()
.includes(value)
?
""
:
"none";


}

);


}

);

</script>



<?php

include "../../includes/footer.php";

?>
