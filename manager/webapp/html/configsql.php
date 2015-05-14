<?php
require 'loginproc.php';
include 'arrays.inc';
$fn = $_GET['fn'];

$fl = fopen("conf/confrc", "w") or die("Unable to open file!");
$txt = "";
$arr = json_decode($_GET['arr']);
foreach ($arr as $key => $val) {
	mysql_query("update naanal.initial_configuration set value='$val' where field_id='$key'", $con);
	$txt = $txt . "export $key=$val\n";

}
fwrite($fl, $txt);
fclose($fl);

if ($fn == "push") {
	$username = $_GET['username'];
	$password = $_GET['password'];
	$login = mysql_query("SELECT * FROM naanal.user WHERE (username = '" . mysql_real_escape_string($username) . "') and (password = '" . mysql_real_escape_string(md5($password)) . "')", $con);
	$key = 0;
	$admin_flag = mysql_result($login, 0, 4);

	if (!(mysql_num_rows($login) == 1)) {
		$rep = "Please Check Username and Password";

	} elseif ($admin_flag == 1) {

		exec("sudo /opt/naanal/manager/scripts/InitialInstallation/ParamReplace.sh");
		$rep = "Settings will be Pushed";
		$key = 1;

	} else {
		$rep = "You don't have privilege to perform this task";
	}
	echo '{ "key":' . $key . ',"reply":"' . $rep . '"}';
}
?>