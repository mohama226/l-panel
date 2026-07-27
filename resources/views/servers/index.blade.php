@extends('admin.layout')


@section('title')

سرورهای OCServ

@endsection



@section('content')


<h1>

سرورهای OCServ

</h1>



<a href="{{route('servers.create')}}">

<button>

افزودن سرور

</button>

</a>



<br><br>




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
SSH
</th>


<th>
عملیات
</th>


</tr>



@foreach($servers as $server)


<tr>


<td>
{{$server->name}}
</td>


<td>
{{$server->ip_address}}
</td>


<td>
{{$server->ssh_port}}
</td>


<td>


<form method="POST"
action="{{route('servers.test',$server)}}">


@csrf


<button>

تست اتصال

</button>


</form>




<form method="POST"
action="{{route('servers.restart',$server)}}">


@csrf


<button>

Restart OCServ

</button>


</form>



</td>



</tr>



@endforeach



</table>


</div>



@endsection
