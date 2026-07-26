<link rel="stylesheet" href="{{ asset('css/login.css') }}">

<div class="login-box">

    <div class="logo">
        L-PANEL
    </div>

    @if($errors->any())
    <div class="error">
        {{ $errors->first() }}
    </div>
    @endif

    <form method="POST" action="/login">
        @csrf

        <div class="input-group">
            <input 
                type="text"
                name="username"
                placeholder="Username">
        </div>

        <div class="input-group">
            <input 
                type="password"
                name="password"
                placeholder="Password">
        </div>

        <button class="login-btn">
            Login
        </button>

    </form>

    <div class="footer">
        Linux VPN Management Panel
    </div>

</div>
