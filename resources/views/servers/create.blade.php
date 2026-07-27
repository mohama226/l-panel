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
action="{{ route('servers.store') }}">


@csrf



<input
name="name"
placeholder="نام سرور">



<input
name="ip_address"
placeholder="IP Address">



<input
name="ssh_username"
placeholder="SSH Username"
value="root">



<input
name="ssh_port"
placeholder="SSH Port"
value="22">



<input
name="ocserv_port"
placeholder="OCServ Port"
value="443">



<button>

ذخیره

</button>



</form>


</div>


@endsection
