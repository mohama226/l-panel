@extends('admin.layout')



@section('title')

سرورهای OCServ

@endsection




@section('content')


<h1>
سرورهای OCServ
</h1>



<div class="card">


<a href="{{ route('servers.create') }}">

<button>

افزودن سرور

</button>

</a>


</div>




<div class="card">


<table width="100%" border="1" cellpadding="10">


<tr>


<th>
نام
</th>


<th>
IP
</th>


<th>
پورت
</th>


<th>
وضعیت
</th>


<th>
عملیات
</th>


</tr>



@foreach($servers as $server)


<tr>


<td>

{{ $server->name }}

</td>


<td>

{{ $server->ip_address }}

</td>


<td>

{{ $server->ocserv_port }}

</td>


<td>

@if($server->status)

فعال

@else

خاموش

@endif


</td>


<td>


<form method="POST"
action="{{ route('servers.test',$server) }}">


@csrf


<button>

تست اتصال

</button>


</form>



</td>


</tr>


@endforeach



</table>


</div>


@endsection
