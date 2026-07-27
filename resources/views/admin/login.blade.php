<!DOCTYPE html>

<html lang="fa" dir="rtl">


<head>

<meta charset="UTF-8">

<title>
ورود L-PANEL
</title>


<style>


body {

background:#111827;

height:100vh;

display:flex;

align-items:center;

justify-content:center;

font-family:tahoma;

}


.login-box {

background:white;

padding:30px;

width:350px;

border-radius:10px;

}



input {

width:100%;

padding:12px;

margin-bottom:15px;

box-sizing:border-box;

}



button {

width:100%;

padding:12px;

background:#111827;

color:white;

border:none;

cursor:pointer;

}



.error {

color:red;

}


</style>


</head>



<body>



<div class="login-box">


<h2>
L-PANEL
</h2>



@if($errors->any())

<div class="error">

{{ $errors->first() }}

</div>

@endif



<form method="POST"
action="{{ route('admin.login.submit') }}">


@csrf



<input

type="text"

name="username"

placeholder="نام کاربری">


<input

type="password"

name="password"

placeholder="رمز عبور">


<button>

ورود

</button>



</form>


</div>



</body>

</html>
