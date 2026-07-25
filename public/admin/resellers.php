<?php
session_start();
if (!isset($_SESSION['admin'])) {
    header("Location: ../login-admin.php");
    exit;
}

$db = new PDO("mysql:host=localhost;dbname=lpanel;charset=utf8", "lpanel_user", "lpanel_pass");

// افزودن نماینده
if (isset($_POST['add_reseller'])) {
    $user = $_POST['username'];
    $pass = password_hash($_POST['password'], PASSWORD_DEFAULT);

    $stmt = $db->prepare("INSERT INTO resellers (username, password) VALUES (?, ?)");
    $stmt->execute([$user, $pass]);
}

$resellers = $db->query("SELECT * FROM resellers")->fetchAll(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html lang="fa">
<head>
    <meta charset="UTF-8">
    <title>Resellers</title>
    <link rel="stylesheet" href="../assets/css/admin-dashboard.css">
</head>
<body>

<div class="content">
    <h1>🧑‍💼 مدیریت نمایندگان</h1>

    <h3>افزودن نماینده جدید</h3>
    <form method="POST">
        <input type="text" name="username" placeholder="نام کاربری" required>
        <input type="password" name="password" placeholder="رمز عبور" required>
        <button name="add_reseller">افزودن نماینده</button>
    </form>

    <h3>لیست نمایندگان</h3>
    <table>
        <tr>
            <th>نام کاربری</th>
            <th>عملیات</th>
        </tr>

        <?php foreach ($resellers as $r): ?>
        <tr>
            <td><?php echo $r['username']; ?></td>
            <td>
                <a href="reseller-view.php?id=<?php echo $r['id']; ?>">مشاهده</a>
            </td>
        </tr>
        <?php endforeach; ?>
    </table>

</div>

</body>
</html>
