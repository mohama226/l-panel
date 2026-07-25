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

    <hr>

    <h2>عملیات</h2>

    <a class="btn-danger" href="ocserv-servers.php?delete=<?php echo $server_id; ?>">🗑 حذف سرور</a>

</div>

</body>
</html>
