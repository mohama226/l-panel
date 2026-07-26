<!DOCTYPE html>
<html>

<head>

<title>
L-PANEL Github
</title>


<style>

body{
font-family:tahoma;
background:#111827;
color:white;
}

.box{

width:600px;
margin:50px auto;
background:#1f2937;
padding:30px;
border-radius:15px;

}


textarea,input{

width:100%;
padding:10px;
margin-top:10px;

}


button{

background:#2563eb;
color:white;
padding:12px;
border:0;
border-radius:8px;
width:100%;
margin-top:20px;

}


pre{

background:black;
padding:20px;
overflow:auto;

}

</style>


</head>


<body>


<div class="box">


<h2>
GitHub Deploy
</h2>


<form method="POST" action="/admin/github/push">

@csrf


<input 
name="message"
placeholder="Commit message"
value="Update L-PANEL">


<button>
Push To Github
</button>


</form>



@if(session('result'))

<h3>
Result
</h3>

<pre>
{{session('result')}}
</pre>

@endif


</div>


</body>

</html>
