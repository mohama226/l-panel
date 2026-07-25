
<?php

shell_exec("systemctl stop ocserv");
shell_exec("systemctl disable ocserv");
shell_exec("dnf remove -y ocserv");

header("Location: ../ocserv-install.php?status=removed");
exit;
?>
