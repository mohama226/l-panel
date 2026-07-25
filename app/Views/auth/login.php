<?php

$title='ورود مدیر';

ob_start();

?>

<div class="login-wrapper">

<div class="login-card">

<div class="logo">

<img src="/assets/images/logo.png">

</div>

<h2>L-Panel</h2>

<p>OCServ Management Platform</p>

<form method="post" action="/login">

<input
type="hidden"
name="_token"
value="<?= csrf_token();?>">

<div class="mb-3">

<input
class="form-control"
name="username"
placeholder="نام کاربری">

</div>

<div class="mb-3">

<input
type="password"
class="form-control"
name="password"
placeholder="رمز عبور">

</div>

<div class="form-check">

<input
class="form-check-input"
type="checkbox"
name="remember">

<label>

مرا به خاطر بسپار

</label>

</div>

<button
class="btn btn-primary w-100 mt-3">

ورود

</button>

</form>

</div>

</div>

<?php

$content=ob_get_clean();

require APP_PATH.'/Views/layouts/auth.php';
