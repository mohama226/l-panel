@extends('admin.layout')



@section('title')

نمایندگان

@endsection




@section('content')


<h1>

نمایندگان فروش

</h1>



<a href="{{route('resellers.create')}}">


<button>

نماینده جدید

</button>


</a>



<br><br>




<div class="card">


<table width="100%" border="1" cellpadding="10">


<tr>


<th>
ادمین
</th>


<th>
تعداد کاربر
</th>


<th>
تعداد سرور
</th>


<th>
موجودی
</th>


</tr>



@foreach($resellers as $reseller)


<tr>


<td>

{{$reseller->admin->name ?? '-'}}

</td>



<td>

{{$reseller->user_limit}}

</td>



<td>

{{$reseller->server_limit}}

</td>



<td>

{{$reseller->balance}}

</td>



</tr>



@endforeach


</table>


</div>


@endsection
