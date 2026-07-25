<?php
session_start();
require_once __DIR__ . '/../app/Core/Router.php';
Router::run();
