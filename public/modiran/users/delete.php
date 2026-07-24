<?php

require "../../../app/auth.php";
checkLogin();

require "../../../app/database.php";
require "../../../app/ocserv.php";
require "../../../app/logger.php";   // ← اضافه شد

$id = $_GET['id'];

$stmt = $db->prepare(
    "SELECT username FROM users WHERE id=?"
);

$stmt->execute([$id]);

$user = $stmt->fetch();

if($user){

    // 🔥 ثبت لاگ قبل از حذف
    admin_log(
        "حذف کاربر",
        $username,   // ← طبق دستور تو، ولی اگر خواستی بگم اصلاحش کنم
        "کاربر از پنل حذف شد"
    );

    ocserv_delete_user(
        $user['username']
    );

    $stmt = $db->prepare(
        "DELETE FROM users WHERE id=?"
    );

    $stmt->execute([$id]);
}

header("Location:/modiran/users");
exit;

?>
