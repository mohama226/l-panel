@extends('admin.layout')



@section('title')

ساخت کاربر VPN

@endsection





@section('content')



<h1>

ساخت کاربر VPN

</h1>




<div class="card">


<form method="POST"
action="{{route('vpn-users.store')}}">


@csrf




<label>

نام کاربری

</label>


<input

name="username"

style="width:100%;padding:10px;">





<br><br>




<label>

رمز عبور

</label>



<input

name="password"

type="password"

style="width:100%;padding:10px;">





<br><br>




<label>

سرور

</label>



<select name="server_id"
style="width:100%;padding:10px;">



@foreach($servers as $server)


<option value="{{$server->id}}">


{{$server->name}}


</option>


@endforeach



</select>




<br><br>



<label>

تاریخ انقضا

</label>



<input

type="date"

name="expire_date"

style="width:100%;padding:10px;">





<br><br>



<button>

ایجاد کاربر

</button>



</form>


</div>



@endsection
