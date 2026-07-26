<!DOCTYPE html>

<html>

<head>

<title>L-Panel Login</title>

</head>


<body>


<h1>
L-Panel
</h1>


<form method="POST" action="/login">

@csrf


<input 
name="username"
placeholder="Username">


<br><br>


<input 
type="password"
name="password"
placeholder="Password">


<br><br>


<button>
Login
</button>


</form>


</body>

</html>
