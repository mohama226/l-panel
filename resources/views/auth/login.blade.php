<!DOCTYPE html>
<html>
<body>

<h2>L-Panel Login</h2>


<form method="POST" action="/login">

@csrf


<input name="username" placeholder="Username">

<br><br>

<input type="password" name="password" placeholder="Password">


<br><br>

<button>
Login
</button>


</form>


</body>
</html>
