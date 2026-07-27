<!DOCTYPE html>
<html lang="fa" dir="rtl">

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>
        @yield('title', 'L-PANEL')
    </title>


    <style>

        body {

            margin:0;

            font-family:
            Tahoma,
            Arial,
            sans-serif;

            background:#f4f6f9;

        }


        .sidebar {

            width:250px;

            height:100vh;

            background:#111827;

            color:white;

            position:fixed;

            right:0;

            top:0;

            padding-top:20px;

        }


        .sidebar h2 {

            text-align:center;

            margin-bottom:30px;

        }


        .sidebar a {

            display:block;

            color:white;

            padding:12px 20px;

            text-decoration:none;

        }


        .sidebar a:hover {

            background:#1f2937;

        }



        .content {

            margin-right:250px;

            padding:30px;

        }



        .card {

            background:white;

            border-radius:10px;

            padding:20px;

            margin-bottom:20px;

            box-shadow:
            0 2px 8px rgba(0,0,0,.05);

        }



        .stats {

            display:grid;

            grid-template-columns:
            repeat(4,1fr);

            gap:20px;

        }


        .stat-number {

            font-size:32px;

            font-weight:bold;

        }



    </style>


</head>


<body>



<div class="sidebar">


    <h2>
        L-PANEL
    </h2>


    <a href="{{ route('admin.dashboard') }}">
        داشبورد
    </a>


    <a href="{{ route('vpn-users.index') }}">
        کاربران VPN
    </a>


    <a href="{{ route('servers.index') }}">
        سرورهای OCServ
    </a>


    <a href="{{ route('admins.index') }}">
        ادمین‌ها
    </a>


    <a href="{{ route('resellers.index') }}">
        نمایندگان
    </a>



    <form method="POST"
          action="{{ route('admin.logout') }}"
          style="padding:20px">


        @csrf


        <button type="submit">
            خروج
        </button>


    </form>


</div>



<div class="content">


    @yield('content')


</div>



</body>

</html>
