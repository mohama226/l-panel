<!DOCTYPE html>

<html>

<head>
<title>L-Panel Dashboard</title>
</head>


<body>


<h1>
L-Panel Dashboard
</h1>


<p>
Welcome {{ auth()->user()->email }}
</p>


<form method="POST" action="/logout">

@csrf

<button>
Logout
</button>

</form>


</body>

</html>
