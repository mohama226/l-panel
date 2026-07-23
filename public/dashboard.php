<?php

require "../app/auth.php";

checkLogin();


?>


<!DOCTYPE html>

<html dir="rtl">


<head>

<title>L-PANEL</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>


<body>


<div class="container mt-5">


<h1>

L-PANEL Dashboard

</h1>


<hr>


<h3>

خوش آمدید

<?=$_SESSION['admin']['username']?>

</h3>


<a href="logout.php"
class="btn btn-danger">

خروج

</a>


</div>


</body>

</html>
