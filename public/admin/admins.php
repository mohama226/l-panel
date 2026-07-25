<?php
session_start();
if (!isset($_SESSION['admin'])) {
    header("Location: ../login-admin.php");
    exit;
}

require_once __DIR__ . "/../app/db.php";
$db = getDB();

// افزودن ادمین جدید
if (isset($_POST['add_admin'])) {
    $username = $_POST['username'];
    $password = password_hash($_POST['password'], PASSWORD_DEFAULT);
    $role = $_POST['role'];

    $stmt = $db->prepare("INSERT INTO admins (username, password, role) VALUES (?, ?, ?)");
    $stmt->execute([$username, $password, $role]);
}

// بلاک / آنبلاک
if (isset($_GET['block'])) {
    $id = intval($_GET['block']);
    $db->query("UPDATE admins SET role='blocked' WHERE id=$id");
}

if (isset($_GET['unblock'])) {
    $id = intval($_GET['unblock']);
    $db->query("UPDATE admins SET role='admin' WHERE id=$id");
}

// حذف ادمین
if (isset($_GET['delete'])) {
    $id = intval($_GET['delete']);
    $db->query("DELETE FROM admins WHERE id=$id");
}

// لیست ادمین‌ها
$admins = $db->query("SELECT * FROM admins")->fetchAll(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html lang="fa">
<head>
    <meta charset="UTF-8">
    <title>مدیریت ادمین‌ها</title>
</head>
<body>

    <h1>مدیریت ادمین‌ها</h1>

    <h3>افزودن ادمین جدید</h3>
    <form method="POST">
        <input type="text" name="username" placeholder="نام کاربری" required>
        <input type="password" name="password" placeholder="رمز عبور" required>

        <select name="role">
            <option value="admin">ادمین</option>
            <option value="superadmin">سوپرادمین</option>
        </select>

        <button name="add_admin">افزودن ادمین</button>
    </form>

    <h3>لیست ادمین‌ها</h3>
    <table border="1" cellpadding="5">
        <tr>
            <th>ID</th>
            <th>نام کاربری</th>
            <th>نقش</th>
            <th>عملیات</th>
        </tr>

        <?php foreach ($admins as $a): ?>
        <tr>
            <td><?php echo $a['id']; ?></td>
            <td><?php echo $a['username']; ?></td>
            <td><?php echo $a['role']; ?></td>
            <td>
                <?php if ($a['role'] !== 'blocked'): ?>
                    <a href="admins.php?block=<?php echo $a['id']; ?>">بلاک</a>
                <?php else: ?>
                    <a href="admins.php?unblock=<?php echo $a['id']; ?>">آن‌بلاک</a>
                <?php endif; ?>

                <a href="admin-edit.php?id=<?php echo $a['id']; ?>">ویرایش</a>
                <a href="admins.php?delete=<?php echo $a['id']; ?>" style="color:red;">حذف</a>
            </td>
        </tr>
        <?php endforeach; ?>
    </table>

</body>
</html>
