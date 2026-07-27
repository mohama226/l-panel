@extends('admin.layout')


@section('title')

نمایندگان

@endsection



@section('content')


<h1>
نمایندگان فروش
</h1>




<div class="card">


<a href="{{ route('resellers.create') }}">

<button>

نماینده جدید

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
سقف کاربر
</th>


<th>
موجودی
</th>


</tr>



@foreach($resellers as $reseller)


<tr>


<td>

{{ $reseller->admin->name ?? '-' }}

</td>


<td>

{{ $reseller->user_limit }}

</td>


<td>

{{ $reseller->balance }}

</td>


</tr>


@endforeach


</table>


</div>


@endsection
