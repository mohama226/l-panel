<!DOCTYPE html>
<html lang="fa">

<head>
<meta charset="UTF-8">
<title>L-PANEL Login</title>
</head>


<body>


<h2>
L-PANEL
</h2>


<form method="POST" action="/login">

@csrf


<input 
type="text"
name="username"
placeholder="نام کاربری">


<br>


<input
type="password"
name="password"
placeholder="رمز عبور">


<br>


<button type="submit">
ورود
</button>


</form>


@if($errors->any())

<p>
{{$errors->first()}}
</p>

@endif


</body>

</html>
