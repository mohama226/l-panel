<?php

function csrf_token()
{

if(!isset($_SESSION['_token']))
{

$_SESSION['_token']=bin2hex(random_bytes(32));

}

return $_SESSION['_token'];

}
