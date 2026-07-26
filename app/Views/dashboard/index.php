<?php

ob_start();

?>


<h1>
Welcome <?=htmlspecialchars($user['username'])?>
</h1>


<p>
Role:
<?=$user['role']?>
</p>


<a href="/logout">
Logout
</a>


<?php

$content=ob_get_clean();

$title="Dashboard";

require ROOT_PATH.'/app/Views/layouts/main.php';
