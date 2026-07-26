<?php

ob_start();

?>


<h2>
L-Panel Login
</h2>


<form method="POST" action="/login">


<input 
type="hidden"
name="_token"
value="<?=$csrf?>">


<input
name="username"
placeholder="Username">


<input
type="password"
name="password"
placeholder="Password">


<button>
Login
</button>


</form>


<?php


$content=ob_get_clean();

$title="Login";


require ROOT_PATH.'/app/Views/layouts/main.php';
