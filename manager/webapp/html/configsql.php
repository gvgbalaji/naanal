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
	exec("sudo /opt/naanal/manager/scripts/InitialInstallation/ParamReplace.sh");
}
?>