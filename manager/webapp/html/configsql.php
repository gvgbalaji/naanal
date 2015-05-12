<?php
require 'loginproc.php';
include 'arrays.inc';

$fl = fopen("conf/confrc.sh", "w") or die("Unable to open file!");
$txt = "";
$arr = json_decode($_GET['arr']);
foreach ($arr as $key => $val) {
	mysql_query("update naanal.initial_configuration set value='$val' where field_id='$key'", $con2);
	$txt = $txt . "export $key='$val'\n";

}
fwrite($fl, $txt);
fclose($fl);
?>