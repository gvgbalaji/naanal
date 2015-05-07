<?php


require ("loginproc.php");
if (isset($_SESSION['username']) && $_SESSION['admin_flag'] == 0) {

	header('Location: user.php');

}
?>