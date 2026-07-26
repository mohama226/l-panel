<!DOCTYPE html>
<html>
<head>
<title>L-PANEL Login</title>

<style>

body{
background:#111827;
font-family:tahoma;
}

.box{
width:420px;
margin:120px auto;
background:white;
padding:30px;
border-radius:15px;
}


input{
width:100%;
padding:12px;
margin:10px 0;
}


button{
width:100%;
padding:12px;
background:#2563eb;
color:white;
border:0;
border-radius:8px;
}

h2{
text-align:center;
}

.error{
color:red;
text-align:center;
}

</style>

</head>

<body>

<div class="box">

<h2>L-PANEL</h2>


@if($errors->any())

<div class="error">
{{ $errors->first() }}
</div>

@endif


<form method="POST" action="/login">

@csrf


<input 
type="text" 
name="username"
placeholder="Username">


<input 
type="password"
name="password"
placeholder="Password">


<button>
Login
</button>


</form>

</div>


</body>
</html>
