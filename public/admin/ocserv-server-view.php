<?php
session_start();
if (!isset($_SESSION['admin'])) {
    header("Location: ../login-admin.php");
    exit;
}

require_once "../../app/db.php";

$db = getDB();

if (!isset($_GET['id'])) {
    die("Server ID not provided.");
}

$server_id = intval($_GET['id']);

$stmt = $db->prepare("SELECT * FROM ocserv_servers WHERE id = ?");
$stmt->execute([$server_id]);
$server = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$server) {
    die("Server not found.");
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
    <h1>🌐 سرور: <?php echo $server['ip']; ?></h1>

    <div class="cards">

        <div class="card">
            <h3>IP</h3>
            <p><?php echo $server['ip']; ?></p>
        </div>

        <div class="card">
            <h3>SSH User</h3>
            <p><?php echo $server['ssh_user']; ?></p>
        </div>

        <div class="card">
            <h3>SSH Port</h3>
            <p><?php echo $server['ssh_port']; ?></p>
        </div>

    </div>

</div>

</body>
</html>
