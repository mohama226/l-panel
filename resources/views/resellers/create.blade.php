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
action="{{ route('resellers.store') }}">


@csrf



<label>
ادمین نماینده
</label>


<select name="admin_id">


@foreach($admins as $admin)


<option value="{{ $admin->id }}">

{{ $admin->name }}

</option>


@endforeach


</select>



<br>



<input

name="user_limit"

placeholder="تعداد کاربر مجاز">



<input

name="server_limit"

placeholder="تعداد سرور مجاز">



<button>

ساخت نماینده

</button>


</form>


</div>


@endsection
