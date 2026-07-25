<?php
session_start();
if (!isset($_SESSION['admin'])) {
    header("Location: ../login-admin.php");
    exit;
}

$db = new PDO("mysql:host=localhost;dbname=lpanel;charset=utf8", "lpanel_user", "lpanel_pass");

// اضافه کردن سرور جدید
if (isset($_POST['add_server'])) {
    $ip = $_POST['ip'];
    $ssh_user = $_POST['ssh_user'];
    $ssh_pass = $_POST['ssh_pass'];

    $stmt = $db->prepare("INSERT INTO ocserv_servers (ip, ssh_user, ssh_pass) VALUES (?, ?, ?)");
    $stmt->execute([$ip, $ssh_user, $ssh_pass]);
}

// گرفتن لیست سرورها
$servers = $db->query("SELECT * FROM ocserv_servers")->fetchAll(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html lang="fa">
<head>
    <meta charset="UTF-8">
    <title>Ocserv Servers</title>
    <link rel="stylesheet" href="../assets/css/admin-dashboard.css">
</head>
<body>

<div class="content">
    <h1>🌐 مدیریت سرورهای Ocserv</h1>

    <h3>افزودن سرور جدید</h3>
    <form method="POST">
        <input type="text" name="ip" placeholder="IP سرور" required>
        <input type="text" name="ssh_user" placeholder="SSH User" required>
        <input type="password" name="ssh_pass" placeholder="SSH Password" required>
        <button name="add_server">افزودن سرور</button>
    </form>

    <h3>لیست سرورها</h3>
    <table>
        <tr>
            <th>IP</th>
            <th>SSH User</th>
            <th>عملیات</th>
        </tr>

        <?php foreach ($servers as $s): ?>
        <tr>
            <td><?php echo $s['ip']; ?></td>
            <td><?php echo $s['ssh_user']; ?></td>
            <td>
                <a href="ocserv-server-view.php?id=<?php echo $s['id']; ?>">مشاهده</a>
            </td>
        </tr>
        <?php endforeach; ?>
    </table>

</div>

</body>
</html>
