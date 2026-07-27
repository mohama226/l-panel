@extends('admin.layout')



@section('title')

داشبورد

@endsection






@section('content')



<h1>

داشبورد مدیریت L-PANEL

</h1>





<div class="stats">



<div class="stat-box">

<h3>
ادمین‌ها
</h3>

<h1>
{{$stats['admins']}}
</h1>

</div>





<div class="stat-box">

<h3>
کاربران VPN
</h3>

<h1>
{{$stats['users']}}
</h1>

</div>





<div class="stat-box">

<h3>
سرورها
</h3>

<h1>
{{$stats['servers']}}
</h1>

</div>





<div class="stat-box">

<h3>
نمایندگان
</h3>

<h1>
{{$stats['resellers']}}
</h1>

</div>




</div>






<div class="card">


<h3>
وضعیت سیستم
</h3>



<p>

کاربران فعال:

{{$stats['active_users']}}

</p>



<p>

سیستم مدیریت OCServ آماده است.

</p>



</div>




@endsection
