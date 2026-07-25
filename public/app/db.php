<?php

function getDB() {
    static $db = null;

    if ($db === null) {
        $db = new PDO(
            "mysql:host=localhost;dbname=lpanel;charset=utf8",
            "lpanel_user",
            "lpanel_pass"
        );
        $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    }

    return $db;
}
