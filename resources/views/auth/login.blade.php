<!DOCTYPE html>
<html>
<head>
<title>L-Panel Login</title>
</head>

<body>

<h2>L-Panel Login</h2>


<form method="POST" action="/login">

@csrf


<input 
name="email"
placeholder="Email">


<br>


<input 
type="password"
name="password"
placeholder="Password">


<br>


<button>
Login
</button>


</form>


</body>
</html>
