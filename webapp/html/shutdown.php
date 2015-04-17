<?php
include 'loginproc.php';
include 'arrays.inc';
$fn = $_GET['fn'];
$username = $_GET['username'];
$password = $_GET['password'];
$login = mysql_query("SELECT * FROM naanal.user WHERE (username = '" . mysql_real_escape_string($username) . "') and (password = '" . mysql_real_escape_string(md5($password)) . "')", $con2);
$key = 0;
if (!(mysql_num_rows($login) == 1)) {
	$rep = "Please Check Username and Password";

} else {
	if ($fn == "shutdown" || $fn == "reboot") {

		exec("sudo ./host_shut.py $fn", $out, $res);
		//$rep = print_r($out);
		$rep = "System Will $fn in a minute";
		$key = 1;
	}

}
echo '{ "key":' . $key . ',"reply":"' . $rep . '"}';
?>
