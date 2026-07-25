<?php
session_start();
if (!isset($_SESSION['admin'])) {
    header("Location: ../login-admin.php");
    exit;
}

require_once "../../app/db.php";
$db = getDB();

if (!isset($_GET['id'])) {
    die("Admin ID not provided.");
}

$id = intval($_GET['id']);

$stmt = $db->prepare("SELECT * FROM admins WHERE id=?");
$stmt->execute([$id]);
$admin = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$admin) {
    die("Admin not found.");
}

if (isset($_POST['update_admin'])) {
    $username = $_POST['username'];
    $role = $_POST['role'];

    if (!empty($_POST['password'])) {
        $password = password_hash($_POST['password'], PASSWORD_DEFAULT);
        $stmt = $db->prepare("UPDATE admins SET username=?, password=?, role=? WHERE id=?");
        $stmt->execute([$username, $password, $role, $id]);
    } else {
        $stmt = $db->prepare("UPDATE admins SET username=?, role=? WHERE id=?");
        $stmt->execute([$username, $role, $id]);
    }

    header("Location: admins.php");
    exit;
}
?>
<!DOCTYPE html>
<html lang="fa">
<head>
    <meta charset="UTF-8">
    <title>ویرایش ادمین</title>
    <link rel="stylesheet" href="../assets/css/admin-dashboard.css">
</head>
<body>

<div class="content">
    <h1>✏️ ویرایش ادمین</h1>

    <form method="POST">
        <input type="text" name="username" value="<?php echo $admin['username']; ?>" required>
        <input type="password" name="password" placeholder="رمز جدید (اختیاری)">
        
        <select name="role">
            <option value="admin" <?php if ($admin['role']=='admin') echo 'selected'; ?>>ادمین</option>
            <option value="superadmin" <?php if ($admin['role']=='superadmin') echo 'selected'; ?>>سوپرادمین</option>
            <option value="blocked" <?php if ($admin['role']=='blocked') echo 'selected'; ?>>بلاک شده</option>
        </select>

        <button name="update_admin">ذخیره تغییرات</button>
    </form>

</div>

</body>
</html>
