<?php

require "../../../app/auth.php";
requireSuperAdmin();

require "../../../app/database.php";

$admins = $db->query(
    "SELECT * FROM admins ORDER BY id DESC"
)->fetchAll();

?>

<!DOCTYPE html>
<html lang="fa" dir="rtl">

<head>
<meta charset="UTF-8">
<title>مدیریت مدیران</title>
</head>

<body>

<h2>
مدیریت مدیران
</h2>

<a href="add.php">
+ مدیر جدید
</a>

<table border="1" width="100%">

<tr>
    <th>کاربر</th>
    <th>نام</th>
    <th>سطح</th>
    <th>وضعیت</th>
    <th>عملیات</th>
</tr>

<?php foreach($admins as $a): ?>

<tr>

<td>
    <?=$a['username']?>
</td>

<td>
    <?=$a['fullname']?>
</td>

<td>
    <?=$a['role']?>
</td>

<td>
    <?=$a['status']?>
</td>

<td>

    <a href="edit.php?id=<?=$a['id']?>">
        ویرایش
    </a>

    |

    <a onclick="return confirm('حذف شود؟')" 
       href="delete.php?id=<?=$a['id']?>">
        حذف
    </a>

</td>

</tr>

<?php endforeach; ?>

</table>

</body>
</html>
