<?php
header('content-type:text/html;charset=utf-8');
$mysql = new mysqli('localhost','root','wang2001','sec');
if ($mysqli -> connect_error) {
    die('Failed to connect MySQL Server!'.$mysqli -> connect_error);
}
echo 'Success!';
?>