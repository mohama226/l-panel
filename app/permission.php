<?php


require_once "permissions.php";



function givePermission(
    $admin_id,
    $permission
){

    global $db;


    $stmt=$db->prepare("
        INSERT INTO admin_permissions
        (
        admin_id,
        permission
        )
        VALUES
        (?,?)
    ");


    return $stmt->execute([
        $admin_id,
        $permission
    ]);

}




function removePermission(
    $admin_id,
    $permission
){

    global $db;


    $stmt=$db->prepare("
        DELETE FROM admin_permissions
        WHERE admin_id=?
        AND permission=?
    ");


    return $stmt->execute([
        $admin_id,
        $permission
    ]);

}
