@extends('admin.layout')


@section('title')
کاربران VPN
@endsection



@section('content')


<h1>
لیست کاربران VPN
</h1>



<div class="card">


<a href="{{ route('vpn-users.create') }}">

<button>
ساخت کاربر جدید
</button>

</a>


</div>




<div class="card">


<table width="100%" border="1" cellpadding="10">


<tr>

<th>
نام کاربری
</th>


<th>
سرور
</th>


<th>
تاریخ انقضا
</th>


<th>
وضعیت
</th>


<th>
عملیات
</th>


</tr>



@foreach($users as $user)


<tr>


<td>

{{ $user->username }}

</td>



<td>

{{ $user->server->name ?? '-' }}

</td>



<td>

{{ $user->expire_date }}

</td>



<td>


@if($user->status)

فعال

@else

غیرفعال

@endif


</td>



<td>


<form method="POST"
action="{{ route('vpn-users.destroy',$user) }}">


@csrf

@method('DELETE')


<button>

حذف

</button>


</form>




@if($user->status)


<form method="POST"
action="{{ route('vpn-users.disable',$user) }}">


@csrf


<button>

غیرفعال

</button>


</form>



@else



<form method="POST"
action="{{ route('vpn-users.enable',$user) }}">


@csrf


<button>

فعال

</button>


</form>



@endif



</td>


</tr>


@endforeach


</table>


</div>


@endsection
