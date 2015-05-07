<?php
include 'arrays.inc';
require ("loginproc.php");
require ("blockadmin.php");

$user = $_SESSION['username'];
$auth_cmd = $_SESSION['auth_cmd'];
$fn = $_GET['fn'];
$ins = $_GET['ins'];
$ser = mysql_result(mysql_query("select instance from naanal.user where username='$user'", $con2), 0, 0);

if ($fn == "start") {
	$q = "select power_state from nova.instances where display_name='$ser' and deleted=0";
	$pow_state = mysql_result(mysql_query($q, $con2), 0, 0);

	if ($pow_state == 4 or $pow_state == 3 or $pow_state == 7) {
		$cmd = "nova $auth_cmd start $ser";
		//echo $cmd;
		exec($cmd);
		$cmd2 = "nova $auth_cmd get-vnc-console $ser novnc | awk '{split($4,a,\"Url\");print a[1] }' | awk '/http/'";
		exec($cmd2, $output, $result);
		$ins = $output[0];

	}

} elseif ($fn == "stop") {
	$q = "select power_state,id from nova.instances where display_name='$ser' and deleted=0";
	$query = mysql_query($q, $con2);
	$pow_state = mysql_result($query, 0, 0);
	$id = mysql_result($query, 0, 1);
	if ($pow_state == 1) {
		$cmd = "sudo virsh shutdown --mode acpi instance-" . substr("00000000" . dechex($id), -8);
		//echo $cmd;
		exec($cmd);
	}

} elseif ($fn == "reboot") {
	$cmd = "nova $auth_cmd reboot $ser";
	//echo $cmd;
	exec($cmd);
}

echo "<iframe id='ifr'  width='90%' height='600px' src='$ins'></iframe>";
?>
