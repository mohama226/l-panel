<!DOCTYPE html>
<html>
<body>

<h2>L-Panel Login</h2>

<form method="POST" action="/login">

@csrf

<input name="email" placeholder="Email">

<br><br>

<input type="password" name="password" placeholder="Password">

<br><br>

<button type="submit">
Login
</button>

</form>

</body>
</html>
