<!DOCTYPE html>
<html lang="fa" dir="rtl">

<head>

<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">


<title>
@yield('title','L-PANEL')
</title>


<style>


body{

    margin:0;

    font-family:tahoma,arial;

    background:#f5f6fa;

}



.sidebar{


    position:fixed;

    right:0;

    top:0;

    width:250px;

    height:100vh;

    background:#1e293b;

    color:white;

    padding-top:20px;


}



.sidebar h2{


    text-align:center;


}



.sidebar a{


    display:block;

    color:white;

    padding:12px 20px;

    text-decoration:none;


}



.sidebar a:hover{


    background:#334155;


}



.content{


    margin-right:250px;

    padding:30px;


}



.card{


    background:white;

    padding:20px;

    border-radius:10px;

    margin-bottom:20px;


}



.stats{


    display:grid;

    grid-template-columns:repeat(4,1fr);

    gap:20px;


}



.stat-box{


    background:white;

    padding:25px;

    border-radius:10px;

    text-align:center;


}



</style>


</head>


<body>



<div class="sidebar">


<h2>
L-PANEL
</h2>



<a href="{{route('admin.dashboard')}}">
داشبورد
</a>



<a href="{{route('vpn-users.index')}}">
کاربران VPN
</a>



<a href="{{route('servers.index')}}">
سرورهای OCServ
</a>



<a href="{{route('admins.index')}}">
ادمین‌ها
</a>



<a href="{{route('resellers.index')}}">
نمایندگان
</a>





<form method="POST" action="{{route('admin.logout')}}">

@csrf


<button style="
margin:20px;
padding:10px;
width:200px;
">

خروج

</button>


</form>



</div>





<div class="content">


@yield('content')


</div>



</body>


</html>
