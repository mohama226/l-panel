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
action="{{ route('vpn-users.store') }}">


@csrf



<label>
نام کاربری
</label>


<input
type="text"
name="username"
required>



<br>



<label>
رمز عبور
</label>


<input
type="password"
name="password"
required>



<br>



<label>
سرور
</label>


<select name="server_id">


@foreach(
\App\Models\OcservServer::all()
as $server
)


<option value="{{ $server->id }}">

{{ $server->name }}

</option>


@endforeach


</select>



<br>



<label>
تاریخ انقضا
</label>


<input
type="date"
name="expire_date">



<br>



<button>

ثبت کاربر

</button>


</form>


</div>


@endsection
