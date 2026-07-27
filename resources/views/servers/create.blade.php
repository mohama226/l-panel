@extends('admin.layout')



@section('title')

افزودن سرور

@endsection




@section('content')


<h1>

افزودن OCServ Server

</h1>



<div class="card">


<form method="POST"
action="{{route('servers.store')}}">


@csrf



<input

name="name"

placeholder="نام سرور"

style="width:100%;padding:10px;">



<br><br>



<input

name="ip_address"

placeholder="IP Server"

style="width:100%;padding:10px;">



<br><br>



<input

name="ssh_username"

placeholder="SSH Username"

style="width:100%;padding:10px;">



<br><br>


<input

name="ssh_port"

value="22"

placeholder="SSH Port"

style="width:100%;padding:10px;">



<br><br>



<button>

ذخیره

</button>



</form>


</div>



@endsection
