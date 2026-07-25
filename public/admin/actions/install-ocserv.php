<?php

$port = intval($_POST['port']);

shell_exec("dnf install -y epel-release");
shell_exec("dnf install -y ocserv");

shell_exec("systemctl stop ocserv");

$config_url = "https://raw.githubusercontent.com/mohama226/l-panel/main/public/configs/ocserv.conf";
$config_path = "/etc/ocserv/ocserv.conf";

shell_exec("curl -s $config_url -o $config_path");

shell_exec("sed -i 's/^tcp-port = .*/tcp-port = $port/' $config_path");
shell_exec("sed -i 's/^udp-port = .*/udp-port = $port/' $config_path");

shell_exec("systemctl enable ocserv");
shell_exec("systemctl start ocserv");

header("Location: ../ocserv-install.php?status=installed");
exit;
?>
