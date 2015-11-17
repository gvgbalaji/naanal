<?php 

require ("loginproc.php");
session_destroy();
header('Location: index.php');

?>
