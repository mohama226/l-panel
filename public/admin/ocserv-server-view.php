<?php
session_start();
if (!isset($_SESSION['admin'])) {
    header("Location: ../login-admin.php");
    exit;
}

if (!isset($_GET['id'])) {
    die("Server ID not provided.");
}

$server_id = intval($_GET['id']);

$db = new PDO("mysql:host=localhost;dbname=lpanel;charset=utf8", "lpanel_user", "lpanel_pass");
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

// گرفتن اطلاعات سرور
$stmt = $db->prepare("SELECT * FROM ocserv_servers WHERE id = ?");
$stmt->execute([$server_id]);
$server = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$server) {
    die("Server not found.");
}

$ip = $server['ip'];
$ssh_user = $server['ssh_user'];
$ssh_pass = $server['ssh_pass'];
$ssh_port = $server['ssh_port'];

// تابع اجرای دستور SSH
function ssh_exec_cmd($ip, $user, $pass, $port, $cmd) {
    $connection = ssh2_connect($ip, $port);
    if (!$connection) return "SSH connection failed";

    if (!ssh2_auth_password($connection, $user, $pass)) {
        return "SSH authentication failed";
    }

    $stream = ssh2_exec($connection, $cmd);
    stream_set_blocking($stream, true);
    return trim(stream_get_contents($stream));
}

// گرفتن وضعیت‌ها از سرور
$cpu_load = ssh_exec_cmd($ip, $ssh_user, $ssh_pass, $ssh_port, "grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}'");
$ram_usage = ssh_exec_cmd($ip, $ssh_user, $ssh_pass, $ssh_port, "free -m | awk 'NR==2{printf \"%s/%s MB\", $3,$2}'");
$disk_usage = ssh_exec_cmd($ip, $ssh_user, $ssh_pass, $ssh_port, "df -h / | awk 'NR==2{printf \"%s/%s\", $3,$2}'");
$ocserv_port = ssh_exec_cmd($ip, $ssh_user, $ssh_pass, $ssh_port, "grep '^tcp-port' /etc/ocserv/ocserv.conf | awk '{print $3}'");
$ocserv_version = ssh_exec_cmd($ip, $ssh_user, $ssh_pass, $ssh_port, "ocserv --version 2>/dev/null | head -n1");
$ocserv_status = ssh_exec_cmd($ip, $ssh_user, $ssh_pass, $ssh_port, "systemctl is-active ocserv");
$connections = ssh_exec_cmd($ip, $ssh_user, $ssh_pass, $ssh_port, "ss -ntu | grep ':$ocserv_port' | wc -l");

// ریستارت سرویس
if (isset($_GET['restart'])) {
    ssh_exec_cmd($ip, $ssh_user, $ssh_pass, $ssh_port, "systemctl restart ocserv");
    header("Location: ocserv-server-view.php?id=$server_id&done=restart");
    exit;
}

// حذف سرور
if (isset($_GET['delete'])) {
    $del = $db->prepare("DELETE FROM ocserv_servers WHERE id = ?");
    $del->execute([$server_id]);
    header("Location: ocserv-servers.php?deleted=1");
    exit;
}

?>
<!DOCTYPE html>
<html lang="fa">
<head>
    <meta charset="UTF-8">
    <title>Ocserv Server View</title>
    <link rel="stylesheet" href="../assets/css/admin-dashboard.css">
</head>

<body>

<div class="content">
    <h1>🌐 مدیریت سرور: <?php echo $ip; ?></h1>

    <div class="cards">

        <div class="card">
            <h3>CPU Load</h3>
            <p><?php echo round($cpu_load, 1); ?>%</p>
        </div>

        <div class="card">
            <h3>RAM</h3>
            <p><?php echo $ram_usage; ?></p>
        </div>

        <div class="card">
            <h3>Disk</h3>
            <p><?php echo $disk_usage; ?></p>
        </div>

        <div class="card">
            <h3>Ocserv Port</h3>
            <p><?php echo $ocserv_port ?: "N/A"; ?></p>
        </div>

        <div class="card">
            <h3>Ocserv Version</h3>
            <p><?php echo $ocserv_version ?: "N/A"; ?></p>
        </div>

        <div class="card">
            <h3>Ocserv Status</h3>
            <p><?php echo $ocserv_status; ?></p>
        </div>

        <div class="card">
            <h3>Connections</h3>
            <p><?php echo $connections; ?> اتصال</p>
        </div>

    </div>

    <hr>

    <h2>عملیات</h2>

    <a class="btn" href="ocserv-server-view.php?id=<?php echo $server_id; ?>&restart=1">🔄 ریستارت Ocserv</a>
    <a class="btn-danger" href="ocserv-server-view.php?id=<?php echo $server_id; ?>&delete=1">🗑 حذف سرور</a>

</div>

</body>
</html>
