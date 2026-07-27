@extends('admin.layout')


@section('title')

کاربران VPN

@endsection



@section('content')


<h1>
کاربران VPN
</h1>



<a href="{{route('vpn-users.create')}}">

<button>

ساخت کاربر جدید

</button>

</a>



<br><br>



<div class="card">


<table width="100%" border="1" cellpadding="10">


<tr>

<th>
ID
</th>


<th>
Username
</th>


<th>
Server
</th>


<th>
Expire
</th>


<th>
Status
</th>


<th>
Action
</th>


</tr>



@foreach($users as $user)


<tr>


<td>
{{$user->id}}
</td>


<td>
{{$user->username}}
</td>


<td>
{{$user->server->name ?? '-'}}
</td>


<td>
{{$user->expire_date}}
</td>


<td>


@if($user->status)

فعال

@else

غیرفعال

@endif


</td>



<td>



@if($user->status)


<form method="POST"
action="{{route('vpn-users.disable',$user)}}">

@csrf


<button>

غیرفعال

</button>


</form>


@else


<form method="POST"
action="{{route('vpn-users.enable',$user)}}">

@csrf


<button>

فعال

</button>


</form>


@endif




<form method="POST"
action="{{route('vpn-users.destroy',$user)}}">


@csrf

@method('DELETE')


<button>

حذف

</button>


</form>



</td>



</tr>


@endforeach



</table>


</div>


@endsection
