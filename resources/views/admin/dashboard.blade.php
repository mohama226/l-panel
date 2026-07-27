@extends('admin.layout')


@section('title')

داشبورد

@endsection



@section('content')


<h1>
داشبورد مدیریت L-PANEL
</h1>



<div class="stats">



<div class="card">

<div>
ادمین‌ها
</div>


<div class="stat-number">

{{ $stats['admins'] }}

</div>

</div>





<div class="card">

<div>
سرورهای OCServ
</div>


<div class="stat-number">

{{ $stats['servers'] }}

</div>

</div>





<div class="card">

<div>
کاربران VPN
</div>


<div class="stat-number">

{{ $stats['users'] }}

</div>

</div>





<div class="card">

<div>
نمایندگان
</div>


<div class="stat-number">

{{ $stats['resellers'] }}

</div>

</div>



</div>




<div class="card">


<h3>
وضعیت سیستم
</h3>


<p>

کاربران فعال:

{{ $stats['active_users'] }}

</p>


<p>

سیستم آماده مدیریت OCServ است.

</p>


</div>



@endsection
