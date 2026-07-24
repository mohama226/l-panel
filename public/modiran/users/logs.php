<?php

require "../../../app/auth.php";
checkLogin();

require "../../../app/database.php";

$id = $_GET['id'] ?? 0;

$stmt = $db->prepare("
SELECT *
FROM users
WHERE id=?
");

$stmt->execute([$id]);

$user = $stmt->fetch();

if(!$user){
    die("User not found");
}

include "../../includes/header.php";
include "../../includes/sidebar.php";

$username = $user['username'];

?>

<div class="content">

<div class="users-box">

<h2>
📊 لاگ کاربر:
<?=$username?>
</h2>

<div class="table-box">

<h3>
OCServ Logs
</h3>

<pre style="
background:#111;
color:#0f0;
padding:20px;
border-radius:10px;
direction:ltr;
text-align:left;
max-height:500px;
overflow:auto;
">

<?php

$log = shell_exec(
    "grep " . escapeshellarg($username) . " /storage/logs/user.log | tail -100"
);

echo htmlspecialchars(
    $log ?: "No logs found"
);

?>

</pre>

<h3>
Panel Logs
</h3>

<pre style="
background:#111;
color:#0ff;
padding:20px;
border-radius:10px;
direction:ltr;
text-align:left;
max-height:500px;
overflow:auto;
">

<?php

$log = shell_exec(
    "grep " . escapeshellarg($username) . " /storage/logs/admin.log | tail -100"
);

echo htmlspecialchars(
    $log ?: "No panel logs found"
);

?>

</pre>

</div>

</div>

</div>

<?php
include "../../includes/footer.php";
?>
