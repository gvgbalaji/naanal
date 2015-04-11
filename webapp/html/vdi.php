<?php
include 'arrays.inc';
require 'loginproc.php';

foreach ($vdinav as $val) {
	$fn = strtolower(str_replace(" ", "", $val)) . "sql" . "()";

	$id = strtolower($val);
	echo '<input type="button" id="' . $id . '" class="topnav-button"  value="' . $val . '" onclick="' . $fn . '">';
}
?>