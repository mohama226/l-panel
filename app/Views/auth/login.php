<?php

ob_start();
?>

<h2>L-Panel Login</h2>

<form method="post">

<input
type="text"
placeholder="Username"
name="username">

<input
type="password"
placeholder="Password"
name="password">

<button>

Login

</button>

</form>

<?php

$content=ob_get_clean();

$title='Login';

require ROOT_PATH.'/app/Views/layouts/main.php';
