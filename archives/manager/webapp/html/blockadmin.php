<?php


require ("loginproc.php");
if (isset($_SESSION['username']) && $_SESSION['admin_flag'] == 1) {

	header('Location: home.php');

}
?>