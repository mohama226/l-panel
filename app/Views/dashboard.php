<!doctype html>

<html>

<head>

<meta charset="utf-8">

<title>L-Panel Dashboard</title>

<link rel="stylesheet" href="/assets/css/dashboard.css">

</head>


<body>


<div class="sidebar">

<h2>
L-Panel
</h2>


<a href="/dashboard">
Dashboard
</a>


<a href="/logout">
Logout
</a>


</div>



<div class="content">


<h1>
Welcome <?= htmlspecialchars($username) ?>
</h1>


<div class="box">

<h3>
Panel Status
</h3>


<p>
L-Panel is running successfully.
</p>


</div>



</div>


</body>

</html>
