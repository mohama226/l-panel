<?php
session_start();
if (!isset($_SESSION['admin'])) {
    header("Location: ../login-admin.php");
    exit;
}

require_once __DIR__ . "/../app/db.php";
$db = getDB();

$id = intval($_GET['id']);

$stmt = $db->prepare("SELECT * FROM admins WHERE id=?");
$stmt->execute([$id]);
$admin = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$admin) die("Not found");

if (isset($_POST['update_admin'])) {
    $u = $_POST['username'];
    $r = $_POST['role'];

    if (!empty($_POST['password'])) {
        $p = password_hash($_POST['password'], PASSWORD_DEFAULT);
        $stmt = $db->prepare("UPDATE admins SET username=?, password=?, role=? WHERE id=?");
        $stmt->execute([$u, $p, $r, $id]);
    } else {
        $stmt = $db->prepare("UPDATE admins SET username=?, role=? WHERE id=?");
        $stmt->execute([$u, $r, $id]);
    }

    header("Location: admins.php");
    exit;
}
?>
<!DOCTYPE html>
<html>
<body>

<h1>ویرایش ادمین</h1>

<form method="POST">
    <input name="username" value="<?php echo $admin['username']; ?>" required>
    <input name="password" placeholder="رمز جدید (اختیاری)">
    <select name="role">
        <option value="admin" <?php if ($admin['role']=='admin') echo 'selected'; ?>>ادمین</option>
        <option value="superadmin" <?php if ($admin['role']=='superadmin') echo 'selected'; ?>>سوپرادمین</option>
        <option value="blocked" <?php if ($admin['role']=='blocked') echo 'selected'; ?>>بلاک</option>
    </select>
    <button name="update_admin">ذخیره</button>
</form>

</body>
</html>
