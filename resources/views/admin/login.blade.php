<!DOCTYPE html>

<html lang="fa" dir="rtl">


<head>


<meta charset="UTF-8">


<title>
ورود L-PANEL
</title>


<style>


body{


background:#f1f5f9;

font-family:tahoma;


}



.login{


width:350px;

margin:120px auto;

background:white;

padding:30px;

border-radius:10px;


}



input{


width:100%;

padding:12px;

margin-bottom:15px;


}



button{


width:100%;

padding:12px;

background:#2563eb;

color:white;

border:0;


}



.error{


color:red;


}


</style>


</head>


<body>



<div class="login">


<h2>
ورود مدیریت
</h2>




@if($errors->any())

<div class="error">

{{$errors->first()}}

</div>

@endif




<form method="POST" action="{{route('admin.login.submit')}}">

@csrf



<input

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
