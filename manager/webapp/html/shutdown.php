<?php
include 'loginproc.php';
include 'arrays.inc';
include 'zmq_fn.php';
$fn = $_GET['fn'];
$username = $_GET['username'];
$password = $_GET['password'];
$login = mysql_query("SELECT * FROM naanal.user WHERE (username = '" . mysql_real_escape_string($username) . "') and (password = '" . mysql_real_escape_string(md5($password)) . "')", $con2);
$key = 0;
$admin_flag = mysql_result($login, 0, 4);
if (!(mysql_num_rows($login) == 1)) {
	$rep = "Please Check Username and Password";

} elseif ($admin_flag == 1) {
	if ($fn == "shutdown" || $fn == "reboot") {

		//exec("sudo ./host_shut.sh $fn", $out, $res);
		//$rep = print_r($out);
		//$cmd = "sudo /opt/naanal/controller/scripts/remote/host_shut.sh $fn";
		$arr1 = array('fn' => 'power', 'sub_fn' => $fn);
		$out = zmq_exec($arr1);

		$rep = "System Will $fn in a minute";
		$key = 1;
	} elseif ($fn == "backup") {
		exec("sudo at -f /opt/naanal/manager/scripts/backup.sh now", $out, $res);

		$rep = "System $fn Will Start in a minute";
		$key = 1;
	}

} else {
	$rep = "You don't have privilege to perform this task";
}
echo '{ "key":' . $key . ',"reply":"' . $rep . '"}';
?>
