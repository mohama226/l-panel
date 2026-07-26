<!DOCTYPE html>

<html>

<head>

<title>L-Panel Login</title>

</head>


<body>


<h2>
L-PANEL
</h2>


@if(session('error'))
<p>
{{session('error')}}
</p>
@endif


<form method="POST" action="/login">

@csrf


<input name="username"
placeholder="Username">


<input name="password"
type="password"
placeholder="Password">


<button>
Login
</button>


</form>


</body>

</html>
