@extends('admin.layout')



@section('title')

ساخت نماینده

@endsection





@section('content')


<h1>

ساخت نماینده

</h1>



<div class="card">


<form method="POST"
action="{{route('resellers.store')}}">


@csrf




<select name="admin_id"
style="width:100%;padding:10px;">



@foreach($admins as $admin)


<option value="{{$admin->id}}">


{{$admin->name}}


</option>


@endforeach


</select>




<br><br>



<input

name="user_limit"

placeholder="محدودیت کاربر"

style="width:100%;padding:10px;">



<br><br>



<input

name="server_limit"

placeholder="محدودیت سرور"

style="width:100%;padding:10px;">



<br><br>



<button>

ایجاد نماینده

</button>



</form>


</div>



@endsection
