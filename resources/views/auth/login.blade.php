<!DOCTYPE html>
<html>
<head>
<title>L-PANEL Login</title>
</head>

<body>

<h2>L-PANEL</h2>


<form method="POST" action="/login">

@csrf

<input 
type="email" 
name="email" 
placeholder="Email">


<br>


<input 
type="password" 
name="password" 
placeholder="Password">


<br>

<button type="submit">
Login
</button>


</form>


</body>
</html>
